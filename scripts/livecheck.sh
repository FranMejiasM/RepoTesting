#!/usr/bin/env bash
#
# Lanza un livecheck de Quality Clouds sobre uno o varios ficheros, igual que el plugin de VS Code
# (POST /api/v2/sf-live-check), y guarda la respuesta en livecheck-results/.
#
# Uso:
#   scripts/livecheck.sh [-e dev|staging|prod] [-r REGEX] [-o FICHERO] fichero [fichero...]
#
#   -e  entorno (por defecto QC_ENV del .env, o dev)
#   -r  muestra solo las issues cuyo bpNameId o texto casen con REGEX (sin distinguir mayúsculas)
#   -o  fichero de salida (solo con un fichero de entrada)
#
# Ejemplos:
#   scripts/livecheck.sh force-app/main/default/classes/AvoidDuplicateBranchConditions.cls
#   scripts/livecheck.sh -e staging -r duplicate force-app/main/default/classes/AvoidDuplicateBranchConditions.cls
#
# Configuración en .env (en la raíz del repo, ya está en .gitignore):
#   QC_ENV=dev
#   QC_API_KEY_DEV=...
#   QC_API_KEY_STAGING=...
#   QC_API_KEY_PROD=...
#   # Opcional: QC_URL_<ENV> para apuntar a otra URL (p. ej. QC_URL_LOCAL=http://localhost:8080 y -e local)
#
# Requiere curl y node.

set -euo pipefail

ROOT="$(cd "$(git -C "$(dirname "$0")" rev-parse --show-toplevel)" && pwd)"
[[ -f "$ROOT/.env" ]] && set -a && . "$ROOT/.env" && set +a

ENV_NAME="${QC_ENV:-dev}"
FILTER=""
OUT=""

while getopts "e:r:o:h" opt; do
	case "$opt" in
		e) ENV_NAME="$OPTARG" ;;
		r) FILTER="$OPTARG" ;;
		o) OUT="$OPTARG" ;;
		h) sed -n '2,25p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
		*) exit 2 ;;
	esac
done
shift $((OPTIND - 1))

if [[ $# -eq 0 ]]; then
	echo "Falta el fichero a analizar. Usa -h para ver la ayuda." >&2
	exit 2
fi
if [[ -n "$OUT" && $# -gt 1 ]]; then
	echo "-o solo vale con un fichero de entrada." >&2
	exit 2
fi

ENV_UPPER="$(echo "$ENV_NAME" | tr '[:lower:]' '[:upper:]')"
case "$ENV_NAME" in
	dev) DEFAULT_URL="https://api-development.qualityclouds.com" ;;
	staging) DEFAULT_URL="https://api-staging.qualityclouds.com" ;;
	prod) DEFAULT_URL="https://api.qualityclouds.com" ;;
	*) DEFAULT_URL="" ;;
esac
URL_VAR="QC_URL_$ENV_UPPER"
KEY_VAR="QC_API_KEY_$ENV_UPPER"
BASE_URL="${!URL_VAR:-$DEFAULT_URL}"
API_KEY="${!KEY_VAR:-}"

if [[ -z "$BASE_URL" ]]; then
	echo "Entorno desconocido '$ENV_NAME': usa dev, staging, prod o define $URL_VAR en .env." >&2
	exit 2
fi
if [[ -z "$API_KEY" ]]; then
	echo "Falta $KEY_VAR en $ROOT/.env." >&2
	exit 2
fi

# node en Windows no entiende rutas /c/...; en Git Bash se convierten con cygpath
to_native() {
	if command -v cygpath >/dev/null 2>&1; then cygpath -m "$1"; else echo "$1"; fi
}

mkdir -p "$ROOT/livecheck-results"

for FILE in "$@"; do
	ABS="$(cd "$(dirname "$FILE")" && pwd)/$(basename "$FILE")"
	# Mismo element-name que manda el plugin: ruta relativa al repo y sin -meta.xml
	ELEMENT_NAME="/${ABS#"$ROOT"/}"
	ELEMENT_NAME="${ELEMENT_NAME%-meta.xml}"
	RESULT="${OUT:-$ROOT/livecheck-results/$(basename "${FILE%-meta.xml}")-$ENV_NAME.json}"

	echo "==> $ELEMENT_NAME  [$ENV_NAME: $BASE_URL]"

	# MSYS_NO_PATHCONV: sin él, Git Bash convierte "/force-app/..." en "C:/Program Files/Git/force-app/..."
	HTTP_CODE="$(
		MSYS_NO_PATHCONV=1 node -e '
			const fs = require("fs");
			process.stdout.write(JSON.stringify({
				"element-name": process.argv[1],
				"element-content": fs.readFileSync(process.argv[2], "utf8"),
				"extension-version": "livecheck.sh"
			}));
		' "$ELEMENT_NAME" "$(to_native "$ABS")" |
		curl -sS -o "$RESULT" -w "%{http_code}" \
			-X POST "$BASE_URL/api/v2/sf-live-check" \
			-H "Authorization: Bearer $API_KEY" \
			-H "Client-Name: SalesforceVSCPlugin" \
			-H "Content-Type: application/json" \
			--data-binary @-
	)"

	if [[ "$HTTP_CODE" != "200" ]]; then
		echo "HTTP $HTTP_CODE" >&2
		cat "$RESULT" >&2
		echo >&2
		exit 1
	fi

	node -e '
		const fs = require("fs");
		const data = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
		const filter = process.argv[2] ? new RegExp(process.argv[2], "i") : null;
		const issues = (data.issues || [])
			.filter(i => !filter || filter.test(i.bpNameId || "") || filter.test(i.issueType || "") || filter.test(i.issueText || ""))
			.sort((a, b) => (a.lineNumber ?? 0) - (b.lineNumber ?? 0) || String(a.bpNameId).localeCompare(String(b.bpNameId)));
		console.log("scanId " + data.scanId + ": " + issues.length + " issues" + (filter ? " (filtro: " + process.argv[2] + ", total " + data.issues.length + ")" : ""));
		for (const i of issues) {
			const text = (i.issueType || i.issueText || "").replace(/\s+/g, " ").slice(0, 90);
			console.log(String(i.lineNumber ?? "-").padStart(5) + "  " + String(i.severity || "").padEnd(8) + " " + String(i.bpNameId).padEnd(40) + " " + text);
		}
	' "$(to_native "$RESULT")" "$FILTER"
	echo "Respuesta guardada en $RESULT"
done
