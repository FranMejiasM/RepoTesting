/**
 * @description       : Controller class for lwc instances
 * @author            : Fran Mejías
 * @group             : 
 * @last modified on  : 13-06-2023
 * @last modified by  : Fran Mejías
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   13-06-2023   Fran Mejías   Initial Version
**/
public with sharing class InstanceControllerLWC {
    final static String RS_NAME = 'This_ORG_Temp_URL';
    final static String RS_DESCRIPTION = 'Temporary Remote Setting required to use Metadata API from Apex'; 
    final static String ORG_URL = URL.getSalesforceBaseUrl().toExternalForm();      

    @AuraEnabled
    public static Map<String,Object> isConnected() {
        Map<String,Object> response = new Map<String,Object>();
        Boolean isConnected = false;
        List<QC_User__c> ListQCUser = [SELECT Id, Name, User__c, QC_Active__c, QC_Api_Key_Developer__c, QC_Valid_Until__c ,API_Key_1__c, API_Key_2__c, API_Key_3__c, API_Key_4__c, API_Key_5__c, API_Key_6__c, API_Key_7__c
                                        FROM QC_User__c WHERE User__c = :UserInfo.getUserId() LIMIT 1];
        if(!ListQCUser.isEmpty()){
            if(ListQCUser[0].QC_Valid_Until__c != null && date.today() < ListQCUser[0].QC_Valid_Until__c && ListQCUser[0].QC_Active__c){
                isConnected = true;
            }                
        }else{
            isConnected = false;
        }
        response.put('isConnected', isConnected);

        if(isConnected) {
            response.put('expDate', ListQCUser[0].QC_Valid_Until__c);
        }
        return response;
    }

    /**
    * @description Add new API KEY for connection whit QC
    */
    @AuraEnabled
    public static Map<String,Object> addApiKey(String apiKey) {

        Map<String,Object> response = new Map<String,Object>();
        //Split the key
        List<String> chunks = new List<String>();
        Integer chunkSize = 175;
        Integer numChunks = (apiKey.length() + chunkSize - 1) / chunkSize;
        
        for(Integer i = 0; i < numChunks; i++){
            Integer startIdx = i * chunkSize;
            Integer endIdx = Math.min((i + 1) * chunkSize, apiKey.length());
            chunks.add(apiKey.substring(startIdx, endIdx));
        }
        //Check if any other user uses the same api key
        if(validateApiKey(chunks)){
            try {

                HTTPResponse res = ControllerHelperQC.accessAPIKEY(apiKey);
                
                if (res != null && res.getStatusCode() == 200){
                    Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    Map<String, Object> data = (Map<String, Object>)body.get('data');
                    Map<String, Object> attributes= (Map<String, Object>)data.get('attributes');
                    
                    //Save data in Salesforce User
                    List<QC_User__c> UserList = [SELECT Id, Name, User__c, QC_Active__c, QC_Api_Key_Developer__c, QC_Valid_Until__c ,API_Key_1__c, API_Key_2__c, API_Key_3__c, API_Key_4__c, API_Key_5__c, API_Key_6__c, API_Key_7__c
                                                    FROM QC_User__c  WHERE User__c =: UserInfo.getUserId() LIMIT 1]; 
                    
                    QC_User__c loginUser = new QC_User__c();
                    
                    if(!UserList.isEmpty()){
                        loginUser = UserList[0];
                    }else{
                        loginUser.User__c = UserInfo.getUserId();
                        loginUser.Name = UserInfo.getName();
                    }
                    
                    if(attributes.get('valid-until') != null){
                        loginUser.QC_Valid_Until__c = Date.valueOf(attributes.get('valid-until')+' 00:00:00');
                    }
                    if(attributes.get('active') != null){
                        loginUser.QC_Active__c = Boolean.valueOf(attributes.get('active'));
                    }
                    if(attributes.get('api-key-developer') != null){
                        loginUser.QC_Api_Key_Developer__c = attributes.get('api-key-developer').toString();
                    }
                    
                    loginUser.API_Key_1__c = chunks[0];
                    loginUser.API_Key_2__c = chunks[1];
                    loginUser.API_Key_3__c = chunks[2];
                    loginUser.API_Key_4__c = chunks[3];
                    loginUser.API_Key_5__c = chunks[4];
                    loginUser.API_Key_6__c = chunks[5];
                    if(chunks.size() > 6){
                        loginUser.API_Key_7__c = chunks[6];
                    }else{
                        loginUser.API_Key_7__c = '';
                    }           
        
                    upsert loginUser;
                    response.put('isSuccess', 'OK');
                    response.put('message', 'Connection with Quality Clouds established');
                    response.put('expDate', loginUser.QC_Valid_Until__c);
                    
                }else{
                    response.put('isSuccess', 'KO');
                    response.put('message', 'Error connecting with Quality Clouds');
                }
            } catch (Exception e) {
                response.put('isSuccess', 'KO');
                response.put('message', 'Error connecting with Quality Clouds');
            }
        }else{
            response.put('isSuccess', 'KO');
            response.put('message', 'This API KEY is already in use please generate a new one');
        }
        system.debug('SALE');       
        system.debug('response: ' + response);  
        return response;
    }

    /**
    * @description Validate that the API KEY is not being used by other users
    */
    private static Boolean validateApiKey(List<String> chunks){
        
        Boolean valid = true;
        
        List<QC_User__c> userList = [SELECT API_Key_1__c, API_Key_2__c, API_Key_3__c, API_Key_4__c, API_Key_5__c, API_Key_6__c, API_Key_7__c
                                        FROM QC_User__c];
        
        if(!userList.isEmpty()){
            for ( QC_User__c QCUser : userList) {
                if( QCUser.API_Key_1__c == chunks[0]&& QCUser.API_Key_2__c == chunks[1] && QCUser.API_Key_3__c == chunks[2] && QCUser.API_Key_4__c == chunks[3] & QCUser.API_Key_5__c == chunks[4] & QCUser.API_Key_6__c == chunks[5]){
                    if(chunks.size() > 6){
                        if( QCUser.API_Key_7__c == chunks[6]){
                            valid = false;
                        }
                    }else{
                        valid = false;
                    }
                }
            }
        }
        return valid;
    }    
        /**
    * @description Retrieve the Instances of QualityClouds
    */
    @AuraEnabled
    public static List<instanceWrapper> getInstances(){
        String SCAN_SUCCESS = 'position: absolute; right: 0px; color: green;';
        String SCAN_FAILED  = 'position: absolute; right: 0px; color: red;';
        String NEVER_SCANNED = 'position: absolute; right: 0px; color: grey;';

        List<instanceWrapper> result = new List<instanceWrapper>();

        if (!Schema.sObjectType.Instance__c.isAccessible()) {
            throw newException('Instance__c is not accessible for current user.');
        } 
        for(Instance__c instances : [SELECT Id, url__c, Description__c, ID__c, (SELECT Id, Date__c, State__c, Total_Issues__c FROM Scanns__r ORDER BY CreatedDate DESC limit 1)  FROM Instance__c WHERE Is_Featured_Banch__c = true ORDER BY CreatedDate DESC LIMIT 100]) {
            instanceWrapper wrap = new instanceWrapper();
            wrap.Description = instances.Description__c;
            wrap.URL = instances.url__c;
            wrap.instanceId = instances.Id;
            wrap.ScanFailed = false;
            if(!instances.Scanns__r.isEmpty()){                
                switch on instances.Scanns__r[0].State__c {
                    when 'RUNNING' {
                        wrap.ScanStatus = 'Last scan is still running';
                        wrap.ScanStyle = SCAN_SUCCESS;
                    }                    
                    when 'FAIL' {
                        wrap.ScanStatus = 'Last scan failed';
                        wrap.ScanStyle = SCAN_FAILED;
                        wrap.ScanFailed = true;
                    }
                    when 'SUCCESS' {
                        wrap.ScanStatus = 'Last scan successful';
                        wrap.ScanStyle = SCAN_SUCCESS;
                    }                
                    when else {
                        wrap.ScanStatus = instances.Scanns__r[0].State__c;
                    }
                }
                wrap.ScanDate = instances.Scanns__r[0].Date__c.format();
                wrap.Issues = String.valueOf(instances.Scanns__r[0].Total_Issues__c);
            } 
            else {
                wrap.ScanStatus = 'Target never scanned';
                wrap.ScanDate = 'Never scanned';
                wrap.ScanStyle = NEVER_SCANNED;
                wrap.Issues = null;
            }
           
            result.add(wrap);
        }            
        if (result.isEmpty()) {
            throw newException('There is no any instance available.');
        } 
        return result;
    }

    /**
    * @description Update the Instances 
    */
    @AuraEnabled
    public static Map<String,Object> updateInstances(){
        Map<String,Object> response = new Map<String,Object>();

        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        if (!Schema.sObjectType.Instance__c.isUpdateable() || !Schema.sObjectType.Instance__c.isCreateable()) {
            throw newException('Current user has no create/update permission for Instance__c object.');
        }
        HttpRequest req = new HttpRequest();

        req.setEndpoint(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/salesforce-instance');
        req.setMethod('GET');
        req.setHeader('Accept', '*/*');
        req.setHeader('client-name', 'Salesforce');
        req.setHeader('Authorization', 'Bearer '+ ControllerHelperQC.getAPIKEY());                
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if (res.getStatusCode() == 200){
            jsoninstancecontent.Jsoninstancecontent_c results =  jsoninstancecontent.Jsoninstancecontent_c.parse(res.getBody());
            List<Instance__c> fetched_instances = new List<Instance__c>();
            for (jsoninstancecontent.Data result : results.data) {
                fetched_instances.add( new Instance__c(url__c=result.attributes.url, Description__c=result.attributes.description, Environment_Type__c=result.attributes.environment,ID__c=result.id, Instance_Type__c=result.attributes.service_name, Is_Featured_Banch__c=result.attributes.is_feature_branch, Inst_Org_Id__c=result.attributes.org_id));
            }
            if (fetched_instances?.isEmpty()){
                response.put('isSuccess', 'WARN');
                response.put('message', 'No instances found on the Quality Clouds portal for this account.');
            } else {
                upsert fetched_instances ID__c;
                response.put('isSuccess','OK');
                response.put('message', 'Instances are imported/updated.');                
            }
        } else {
            response.put('isSuccess','KO');
            response.put('message', res.getBody());
        }
        return response;
    }

    public class instanceWrapper {
        @AuraEnabled public String Description {get;set;}
        @AuraEnabled public String URL {get;set;}
        @AuraEnabled public String ScanStatus {get;set;}
        @AuraEnabled public String ScanDate {get;set;}
        @AuraEnabled public String Issues {get;set;}
        @AuraEnabled public String instanceId {get;set;}
        @AuraEnabled public Boolean ScanFailed {get;set;}        
        @AuraEnabled public String ScanStyle {get;set;}
        }

    private static AuraHandledException newException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }        
}