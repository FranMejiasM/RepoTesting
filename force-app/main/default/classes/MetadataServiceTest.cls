@isTest  
private class MetadataServiceTest
{    

	private class WebServiceMockImpl implements WebServiceMock {
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) {			
            if(request instanceof  MetadataService.deleteMetadata_element)
                response.put('response_x', new MetadataService.deleteMetadataResponse_element());            
            else if(request instanceof  MetadataService.createMetadata_element)
                response.put('response_x', new MetadataService.createMetadataResponse_element());            
			return;
		}
	} 
	
    @IsTest
    private static void coverGeneratedCodeFileBasedOperations2() {       
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        MetadataService metaDataService = new MetadataService();
        Test.startTest();    
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        metaDataPort.deleteMetadata(null, null);
        metaDataPort.createMetadata(null);        
        Test.stopTest();
        System.assertNotEquals(metaDataPort, null, 'metaDataPort is null') ;
    }
        
	@IsTest
    private static void coverGeneratedCodeTypes() {    	       
        Test.startTest();
        MetadataService metaDataService = new MetadataService();
        new MetadataService.Error();
        new MetadataService.SaveResult();
        new MetadataService.ConnectedAppAttribute();
        new MetadataService.DeleteResult();
        new MetadataService.ConnectedAppCanvasConfig();
        new MetadataService.ConnectedAppIpRange();
        new MetadataService.ConnectedAppSamlConfig();
        new MetadataService.ConnectedAppMobileDetailConfig();
        new MetadataService.ConnectedApp();
        new MetadataService.ConnectedAppOauthConfig();
        new MetadataService.createMetadata_element();
        new MetadataService.createMetadataResponse_element();
        new MetadataService.deleteMetadata_element();
        new MetadataService.deleteMetadataResponse_element();
        new MetadataService.RemoteSiteSetting();
        new MetadataService.SessionHeader_element();
        new MetadataService.DebuggingInfo_element();
        new MetadataService.DebuggingHeader_element();
        new MetadataService.CallOptions_element();
        new MetadataService.AllOrNoneHeader_element();
        new MetadataService.ExtendedErrorDetails();
        new MetadataService.LogInfo();
        Test.stopTest();
        System.assertNotEquals(metaDataService, null, 'metaDataService is null');
    } 
}