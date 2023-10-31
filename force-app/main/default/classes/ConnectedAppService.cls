public with sharing class ConnectedAppService {
    public class ConnectedAppServiceException extends Exception { }
    final static String ORG_URL = String.valueOf(System.Url.getOrgDomainUrl().toExternalForm());

    public static Boolean checkIfNoQCConnectedApp(){
        if ([SELECT Name FROM ConnectedApplication where Name = 'QualityClouds'].isEmpty()){
            return true;
        } 
        return false;     
    } 

    private static MetadataService.MetadataPort createService(){    
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }

    public static Boolean deleteConnectedApp (String appName){
        return deleteMetadata('ConnectedApp', appName);
    } 

    public static Boolean deleteRemoteSiteSetting (String appName){        
        if (checkIfNoRemoteSiteSettingByName(appName)){
            return true;
        }
        return deleteMetadata('RemoteSiteSetting', appName);
    } 

    private static Boolean deleteMetadata (String metadataType, String appName){        
        MetadataService.MetadataPort service = createService();
        List<MetadataService.DeleteResult> results = service.deleteMetadata(metadataType, new String[] { appName });
        if((results != null) && (results[0]?.success)){
            return true;
        }
        throw new ConnectedAppServiceException('Failed to delete ' + metadataType + ' "' + appName + '". Response: ' + results);
    } 

    public static Map<String, String> createConnectedApp(String qcCallbackURL){
        MetadataService.MetadataPort service = createService();
        MetadataService.ConnectedApp connectedApp = new MetadataService.ConnectedApp();
        MetadataService.ConnectedAppOauthConfig oauthConfig = new MetadataService.ConnectedAppOauthConfig();        
        connectedApp.label = 'QualityClouds';
        connectedApp.fullName = 'QualityClouds';
        connectedApp.contactEmail = 'help@qualityclouds.com';
        connectedApp.contactPhone = '+44 20 3290 0456';
        connectedApp.description = 'QualityClouds connection for REST API calls';        
        String consumKey = ControllerHelperQC.generateRandomString(100, false);
        String consumSecret = ControllerHelperQC.generateRandomString(64, true);
        oauthConfig.consumerKey = consumKey;
        oauthConfig.consumerSecret = consumSecret;
        oauthConfig.scopes = new List<String>{'Api', 'RefreshToken'};
        oauthConfig.callbackUrl = qcCallbackURL;        
        connectedApp.oauthConfig = oauthConfig;
        List<MetadataService.SaveResult> results = service.createMetadata(new MetadataService.Metadata[] { connectedApp });
        if((results != null) && (results[0]?.success)){
            Map<String, String> keys = new Map<String, String>();
            keys.put('consumKey',consumKey);
            keys.put('consumSecret', consumSecret);
            return keys;
        }  
        throw new ConnectedAppServiceException('Failed to create connected app. Response: ' + results);
    } 

    public static Boolean createRemoteSiteSetting(String name, String description, String url){
        if (!checkIfNoRemoteSiteSettingByName(name)){
            return true;
        }	
        Map<String, Object> metadata = new Map<String, Object>();
        metadata.put('description', description);
        metadata.put('isActive', true);
        metadata.put('url', url);
        Map<String, Object> jsonObj= new Map<String, Object>();
        jsonObj.put('FullName', name);
        jsonObj.put('Metadata', metadata);
        String json = JSON.serialize(jsonObj);
        String endpoint = ORG_URL +'/services/data/v47.0/tooling/sobjects/RemoteProxy/';
        string method  = 'POST';	
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(endpoint);
        request.setMethod(method);
        request.setBody(json); 
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response?.getStatusCode() == 201){
            return true;
        }
        throw new ConnectedAppServiceException('**** Error Remote Site Setting cretion: ' +  response?.getBody());
    }

    private static List<RemoteSiteSetting> getRemoteSiteSettings(){	
        String endpoint = ORG_URL +'/services/data/v47.0/tooling/query?q=Select+Id,+EndpointUrl,+Description,+IsActive,+SiteName+from+RemoteProxy';
        string method  = 'GET';
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(endpoint);
        request.setMethod(method); 
        Http http = new Http();
        HttpResponse response = http.send(request);
        RemoteSiteSettings result = (RemoteSiteSettings)JSON.deserialize(response.getBody(), ConnectedAppService.RemoteSiteSettings.class);
        return result.records;
    }

    private static Boolean checkIfNoRemoteSiteSettingByName(String rsName){
        for (RemoteSiteSetting RSsetting : getRemoteSiteSettings()) {
            if (RSsetting.SiteName == rsName){
                return false;
            }
        }
        return true;
    }

    public class RemoteSiteSettings{
        public List<RemoteSiteSetting> records;
    }

    public class RemoteSiteSetting{
        public String Id;
        public String EndpointUrl;
        public String Description;
        public Boolean IsActive;
        public String SiteName;
    }
}