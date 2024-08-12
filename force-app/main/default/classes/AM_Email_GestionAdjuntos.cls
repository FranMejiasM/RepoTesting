public class AM_Email_GestionAdjuntos {
    public static void gestionAdjuntos(Messaging.InboundEmail email, Case caso, String myPlainText, String emailDestino) {

        // Adjuntos del email se convierten en Files asociados al caso
        List<Id> listaContentVersionIdEmail = new List<Id>();

        String nuevoHtmlBody = email.htmlBody;
        if (!String.isBlank(nuevoHtmlBody) && nuevoHtmlBody.length() > 32000) {
            nuevoHtmlBody = nuevoHtmlBody.left(32000);
        }

        if (email.textAttachments != null) {
            for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                ContentVersion cv = new ContentVersion();
                cv.ContentLocation = 'S';
                cv.PathOnClient = tAttachment.fileName;
                cv.Origin = 'H';
                cv.Title = tAttachment.fileName;
                cv.VersionData = Blob.valueOf(tAttachment.body);
                insert cv;

                listaContentVersionIdEmail.add(cv.Id);
                ContentVersion cVers = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
                ContentDocumentLink cl = new ContentDocumentLink(LinkedEntityId = caso.Id, ContentDocumentId = cVers.ContentDocumentId, ShareType = 'I');
                insert cl;
            }
        }
    }
}
