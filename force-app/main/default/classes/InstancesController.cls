/**
* @description Controller Class of the Instance Visual Force Page
*/
public with sharing class InstancesController {
    public String message_type_out{get;set;}
    public String message_out{get;set;}
    public String message{get;set;}
    public String message_type{get;set;}
    
    List<Instance__c> instances;
    QualityCloudsSettings__mdt settings;
    public String id_inst{get;set;}
    public boolean showPopup {get;set;}
    public String description {get;set;}
    final static String ORG_URL = URL.getSalesforceBaseUrl().toExternalForm();
    final static String ORG_ID =  UserInfo.getOrganizationId();
    final static String RS_NAME = 'This_ORG_Temp_URL';
    final static String RS_DESCRIPTION = 'Temporary Remote Setting required to use Metadata API from Apex'; 
    public String apiKey {get;set;}
    public Boolean showSetup { get; set; }
    
    /**
    * @description Get and Set QC_User__c variable in Page
    */
    public static QC_User__c QCUser { 
        get {
            if (QCUser == null) {
                List<QC_User__c> ListQCUser = [SELECT Id, Name, User__c, QC_Active__c, QC_Api_Key_Developer__c, QC_Valid_Until__c ,API_Key_1__c, API_Key_2__c, API_Key_3__c, API_Key_4__c, API_Key_5__c, API_Key_6__c, API_Key_7__c
                                                FROM QC_User__c WHERE User__c = :UserInfo.getUserId() LIMIT 1];
                if(!ListQCUser.isEmpty()){
                    QCUser = ListQCUser[0];
                }else{
                    return null;
                }
            }
            return QCUser;
        }
        set;
    }
    
        /**
    * @description Get and Set connected variable in Page
    */    
    public static Boolean connected { 
        get {
            connected = false;
            if (QCUser != null) {
                if(QCUser.QC_Valid_Until__c != null && date.today() < QCUser.QC_Valid_Until__c && QCUser.QC_Active__c){
                    connected = true;
                }                
            }
            return connected;
        }
        set;
    }
    
    /**
    * @description Constructor of the Class initizlize the 
    */
    public InstancesController() {
        message = ApexPages.currentPage().getParameters().get('message');
        message_type = ApexPages.currentPage().getParameters().get('message_type');
        showPopup = false;
        description = '';
        showSetup = false;
        
    }
        
    /**
    * @description Retrieve the Instances of QualityClouds
    */
    public List<Instance__c> getInstances(){
        if (!Schema.sObjectType.Instance__c.isAccessible()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Instance__c is not accessible for current user.'));
        } else if (instances == null) {
            instances = [SELECT url__c, Description__c, ID__c, Is_Featured_Banch__c FROM Instance__c WHERE Is_Featured_Banch__c = true ORDER BY CreatedDate DESC LIMIT 100];            
        }   
        return instances;
    }
    
    /**
    * @description Update the Instance Button in the Visualforce Page
    */
    public PageReference updateInstances(){
        if (!Schema.sObjectType.Instance__c.isUpdateable() || !Schema.sObjectType.Instance__c.isCreateable()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Current user has no create/update permission for Instance__c object.'));
            return null;
        }
        HttpRequest req = new HttpRequest();
        settings = ControllerHelperQC.getSettings();
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
                System.debug(result.attributes.url+'-'+ result.attributes.description +'-'+ result.attributes.environment +'-'+ result.id +'-'+result.attributes.service_name +'-'+result.attributes.is_feature_branch+'-'+result.attributes.org_id);
            }
            if (fetched_instances?.isEmpty()){
                message_type_out = 'warning';
                message_out = 'No instances found on the Quality Clouds portal for this account.';                              
            } else {
                upsert fetched_instances ID__c;
                message_type_out = 'confirm';
                message_out = 'Instances are imported/updated.';                
            }
        } else {
            message_type_out = 'error';
            message_out = res.getBody();
        }
        PageReference tempPage = new PageReference('/apex/instances');
        tempPage.getParameters().put('message_type', message_type_out);
        tempPage.getParameters().put('message', message_out);
        tempPage.setRedirect(true);
        return tempPage;
    }
    
    /**
    * @description Link to the Instance Detail Visualforce Page
    */
    public PageReference openDetail(){
        PageReference tempPage = new PageReference('/apex/InstanceDetail');
        tempPage.getParameters().put('id', id_inst);
        tempPage.setRedirect(true);
        return tempPage;
    } 
    
    /**
    * @description Connection to portal and adding description controller
    */
    public PageReference connectOrgToPortal(){ 
        if (String.isBlank(description)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please enter instance description.'));            
            return null;
        }
        
        try {        
            if (ConnectedAppService.checkIfNoQCConnectedApp()) {
                ConnectedAppService.createRemoteSiteSetting( RS_NAME, RS_DESCRIPTION, ORG_URL);
                Map<String, String> keys = ConnectedAppService.createConnectedApp(settings.CallbackURL__c);
                if (!createPortalInstance(keys)){
                    ConnectedAppService.deleteConnectedApp('QualityClouds');
                    ConnectedAppService.deleteRemoteSiteSetting(RS_NAME);
                    message_type_out = 'error';
                    message_out = 'Error creating instance in the portal. QualityClouds connected app is deleted.';
                }else {
                    ConnectedAppService.deleteRemoteSiteSetting(RS_NAME);
                    updateInstances();
                    PageReference tempPage = new PageReference('/apex/instances');
                    tempPage.getParameters().put('message_type', 'confirm');
                    tempPage.getParameters().put('message', 'New instance "' + description + '" created on the portal. Please click "Refresh connection" to authorize the instance.');
                    tempPage.setRedirect(true);
                    return tempPage;
                }
            }else{
                message_type_out = 'info';
                message_out = 'QualityClouds connected app exists. If you need help with configuring the app, please contact QualityClouds support.';
            }        
        } catch (Exception e) {
            System.debug(LoggingLevel.Error, e.getStackTraceString()); 
            message_type_out = 'error';
            message_out = e.getMessage();
        }
        PageReference tempPage = new PageReference('/apex/instances');
        tempPage.getParameters().put('message_type', message_type_out);
        tempPage.getParameters().put('message', message_out);
        tempPage.setRedirect(true);
        return tempPage;
    }    
    
    /**
    * @description Cancel button in the popUp
    */
    public PageReference Cancel(){
        showPopup = false;
        return null;
    }     
    
    /**
    * @description Create a portal Instance whit a POST 19/06/2023 DEPRECATED
    */
    public Boolean createPortalInstance(Map<String, String> keys){
        return true;
    }
    
    /**
    * @description Retrieve the authorization
    */
    public PageReference authorize(){
        HttpRequest req = new HttpRequest();
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();
        req.setEndpoint(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/salesforce-instance/' + id_inst);
        System.debug('req.endpoint'+ req.getEndpoint());
        req.setMethod('GET');
        req.setHeader('Accept', '*/*');
        req.setHeader('client-name', 'Salesforce');
        req.setHeader('Authorization', 'Bearer '+ ControllerHelperQC.getAPIKEY());                
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String oauthURL;
        if (res.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            Map<String, Object> data = (Map<String, Object>) results.get('data');
            Map<String, Object> attributes = (Map<String, Object>) data.get('attributes');
            oauthURL = (String) attributes.get('salesforce-login-url');           
            PageReference tempPage = new PageReference(oauthURL?.replaceAll('&scope=api%20refresh_token',''));   
            System.debug(oauthURL);
            System.debug(tempPage);
            tempPage.setRedirect(true);
            return tempPage;            
        }
        message_out = 'Error getting authorization URL. Please close this tab and get authorization token on Quality Clouds portal';    
        PageReference tempPage = new PageReference('/apex/instances');
        tempPage.getParameters().put('message_type', 'error');
        tempPage.getParameters().put('message', message_out);
                    System.debug(tempPage);
    
        tempPage.setRedirect(true);
        return tempPage;
    }
    
        /**
    * @description Connect to QC button popUp to login credentials
    */
    public PageReference openPopup(){
        PageReference instUpdateResult =  updateInstances();
        if (instUpdateResult.getParameters().get('message_type') == 'error'){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, instUpdateResult.getParameters().get('message'))); 
            return null;
        }
        
        if (ConnectedAppService.checkIfNoQCConnectedApp()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'QualityClouds connected app exists in this org. If you need help with configuring the app, please contact QualityClouds support.')); 
            return null;
        }
        
        if (ControllerHelperQC.checkIfOrgConnected()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'The instance for current org ID exists already, but QualityClouds connected app not found. If you need help with configuring the app, please contact QualityClouds support.')); 
            return null;
        }
        
        showPopup = true;
        return null;
    }
    
    /**
    * @description This method checks is the current KEY is valid
    */
    public Boolean getcheckAPIKEY(){        
        return ControllerHelperQC.checkAPIKEY(); 
    }
        
    /**
    * @description Show API KEY Setup menu
    */
    public void setup() {
        // toggle the showOAuthStatus variable between true and false
        showSetup = !showSetup;
    }
    
    /**
    * @description Add new API KEY for connection whit QC
    */
    public PageReference addApiKey(){
        
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
                message_type_out = 'confirm';
                message_out = 'Connection with Quality Clouds established';
                
            }else{
                message_type_out = 'error';
                message_out = 'Error connecting with Quality Clouds';
            }
        }else{
            message_type_out = 'error';
            message_out = 'This API KEY is already in use please generate a new one';
        }
        
        PageReference tempPage = new PageReference('/apex/instances');
        tempPage.getParameters().put('message_type', message_type_out);
        tempPage.getParameters().put('message', message_out);
        tempPage.setRedirect(true);
        return tempPage;
    }
    
    /**
    * @description Validate that the API KEY is not being used by other users
    */
    
    public static Boolean validateApiKey(List<String> chunks){
        
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
    }