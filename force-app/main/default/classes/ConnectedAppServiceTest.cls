@isTest
class ConnectedAppServiceTest {

    private class WebServiceMockImplNullResponse implements WebServiceMock 
	{
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
            if(request instanceof  MetadataService.deleteMetadata_element){
                 response.put('response_x', new MetadataService.deleteMetadataResponse_element());
            } else if(request instanceof  MetadataService.createMetadata_element){
                 response.put('response_x', new MetadataService.createMetadataResponse_element());
            }			
			return;
		}
	} 
    private class WebServiceMockImplSuccess implements WebServiceMock 
	{
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
            if(request instanceof  MetadataService.deleteMetadata_element){
                MetadataService.DeleteResult deleteResult = new MetadataService.DeleteResult();
                deleteResult.success = true;
                deleteResult.fullName = 'QC';                
                MetadataService.deleteMetadataResponse_element response_x = new MetadataService.deleteMetadataResponse_element();
                response_x.result = new MetadataService.DeleteResult[] { deleteResult };               
                response.put('response_x', response_x);
            } else if(request instanceof  MetadataService.createMetadata_element){
                MetadataService.SaveResult saveResult = new MetadataService.SaveResult();
                saveResult.success = true;
                saveResult.fullName = 'QC';                
                MetadataService.createMetadataResponse_element response_x = new MetadataService.createMetadataResponse_element();
                response_x.result = new MetadataService.SaveResult[] { saveResult };               
                response.put('response_x', response_x);
            }			
			return;
		}
	} 

    private class MockOK implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('tooling/sobjects/RemoteProxy/')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{}');
                res.setStatusCode(201);
                return res;
            } else if (req.getEndpoint().endsWith('tooling/query?q=Select+Id,+EndpointUrl,+Description,+IsActive,+SiteName+from+RemoteProxy')) {
                    HTTPResponse res = new HTTPResponse();
                    res.setBody('{"size":5,"totalSize":5,"done":true,"queryLocator":null,"entityTypeName":"RemoteProxy",'+
                    '"records":[{"attributes":{"type":"RemoteProxy","url":"/services/data/v47.0/tooling/sobjects/RemoteProxy/0rp5Y000000CnO3QAK"},'+
                    '"Id":"0rp5Y000000CnO3QAK","EndpointUrl":"https://dev.qualityclouds.com","Description":null,"IsActive":true,'+
                    '"SiteName":"QualityClouds"},{"attributes":{"type":"RemoteProxy",'+
                    '"url":"/services/data/v47.0/tooling/sobjects/RemoteProxy/0rp5Y000000CnO4QAK"},'+
                    '"Id":"0rp5Y000000CnO4QAK","EndpointUrl":"https://scan.qualityclouds.com","Description":null,"IsActive":true,'+
                    '"SiteName":"QualityCloudsProd"},{"attributes":{"type":"RemoteProxy",'+
                    '"url":"/services/data/v47.0/tooling/sobjects/RemoteProxy/0rp5Y000000CnroQAC"},"Id":"0rp5Y000000CnroQAC",'+
                    '"EndpointUrl":"https://app-api.copa.do","Description":"This remote is needed to perform deployments","IsActive":true,'+
                    '"SiteName":"Copado"},{"attributes":{"type":"RemoteProxy",'+
                    '"url":"/services/data/v47.0/tooling/sobjects/RemoteProxy/0rp5Y000000CnrpQAC"},"Id":"0rp5Y000000CnrpQAC",'+
                    '"EndpointUrl":"https://app-api.copado.com","Description":null,"IsActive":true,"SiteName":"CopadoNew"},'+
                    '{"attributes":{"type":"RemoteProxy","url":"/services/data/v47.0/tooling/sobjects/RemoteProxy/0rp5Y000001ESJ9QAO"},'+
                    '"Id":"0rp5Y000001ESJ9QAO","EndpointUrl":"http://www.apexdevnet.com",'+
                    '"Description":null,"IsActive":true,"SiteName":"ApexDevNet"}]}');
                    res.setStatusCode(200);
                    return res;
            } else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
        }
    } 
  
    @isTest
    static void testcheckIfNoQCConnectedApp() {  
        Boolean expected = [SELECT Name FROM ConnectedApplication where Name = 'QualityClouds'].isEmpty();    
        Test.startTest();  
        Boolean actual = ConnectedAppService.checkIfNoQCConnectedApp();    
        Test.stopTest();  
        System.assertEquals(expected, actual, 'Incorrectly detected QC connected app in the org.') ; 
    }

    @isTest
    static void testdeleteConnectedAppException() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImplNullResponse());
        Test.startTest();
        try {
            ConnectedAppService.deleteConnectedApp('QualityClouds');
        } catch (Exception e){
            System.Assert(e.getMessage().contains('Failed to delete ConnectedApp "QualityClouds". Response: null'));
        }
        Test.stopTest();
    }

    @isTest
    static void testcreateConnectedAppException() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImplNullResponse());
        Test.startTest();
        try {
            ConnectedAppService.createConnectedApp('QualityClouds');
        } catch (Exception e){
            System.Assert(e.getMessage().contains('Failed to create connected app. Response: null'));
        }
        Test.stopTest();
    }

    @isTest
    static void testdeleteConnectedAppOK() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImplSuccess());    
        Test.startTest();    
        System.assertEquals(true, ConnectedAppService.deleteConnectedApp('QC'));   
        Test.stopTest();     
    }

    @isTest
    static void testcreateConnectedAppOK() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImplSuccess()); 
        Test.startTest();       
        Map<String, String> keys = ConnectedAppService.createConnectedApp('QC');
        Test.stopTest();
        System.assertNotEquals(null, keys.get('consumKey'));   
        System.assertNotEquals(null, keys.get('consumSecret'));   

    }

    @isTest
    static void tescreateRemoteSiteSettingOK() {
        Test.setMock(HttpCalloutMock.class, new MockOK());
        Test.startTest();       
        System.assertEquals(true, ConnectedAppService.createRemoteSiteSetting('QC', 'Descr', 'https://test.com')); 
        Test.stopTest();     
    }
}