@IsTest
public class jsontoscanTest {

	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"data\": {'+
		'        \"type\": \"feature-branch-scan\",'+
		'        \"id\": \"25c9fe3b-610a-4cfa-a55d-1cf7db4a3f84\",'+
		'        \"attributes\": {'+
		'            \"url-id\": 348,'+
		'            \"customer-id\": 3333,'+
		'            \"user-id\": 362,'+
		'            \"scan-date\": \"2019-07-23 08:25:59\",'+
		'            \"internal-code\": 1,'+
		'            \"exit-code\": 7,'+
		'            \"status\": \"SUCCESS\",'+
		'            \"customer-name\": \"SUCCESS_NAME\",'+
		'            \"technical-debt\": \"355.0\",'+
		'            \"quality-of-cloud\": \"96.00\",'+
		'            \"scanned-configuration-elements\": 1234,'+
		'            \"target\": \"Test target\",'+
		'            \"number-of-issues\": 789,'+
		'            \"process-time\": \"9.00\",'+
		'            \"engine-version\": \"19.3.0.0-RC_4\",'+
		'            \"scan-details\": \"No detailed information available\",'+
		'            \"quality-gate-message\": \"Quality Gate does not allow code with any new issues. Make sure you solve these first.\",'+
		'            \"is-baseline\": false,'+
		'            \"quality-gate-result\": \"FAIL\"'+
		'        },'+
		'        \"links\": {'+
		'            \"self\": \"https:\\/\\/dev.qualityclouds.com\\/api\\/v2\\/feature-branch-scan\\/25c9fe3b-610a-4cfa-a55d-1cf7db4a3f84\"'+
		'        }'+
		'    }'+
		'}';
		jsontoscan.Jsontoscan_c r = jsontoscan.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		jsontoscan.Attributes objAttributes = new jsontoscan.Attributes(System.JSON.createParser(json));
		System.assert(objAttributes != null);
		System.assert(objAttributes.url_id == null);
		System.assert(objAttributes.customer_id == null);
		System.assert(objAttributes.user_id == null);
		System.assert(objAttributes.scan_date == null);
		System.assert(objAttributes.internal_code == null);
		System.assert(objAttributes.exit_code == null);
		System.assert(objAttributes.status == null);
		System.assert(objAttributes.process_time == null);
		System.assert(objAttributes.engine_version == null);
		System.assert(objAttributes.customer_name == null);
		System.assert(objAttributes.scan_details == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		jsontoscan.Links objLinks = new jsontoscan.Links(System.JSON.createParser(json));
		System.assert(objLinks != null);
		System.assert(objLinks.self == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		jsontoscan.Data objData = new jsontoscan.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.type_Z == null);
		System.assert(objData.id == null);
		System.assert(objData.attributes == null);
		System.assert(objData.links == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		jsontoscan.Jsontoscan_c objJsontoscan = new jsontoscan.Jsontoscan_c(System.JSON.createParser(json));
		System.assert(objJsontoscan != null);
		System.assert(objJsontoscan.data == null);
	}
}