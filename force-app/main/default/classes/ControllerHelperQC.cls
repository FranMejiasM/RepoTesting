/**
* @description The helper manages much of the creditals and scans of Quality Clouds 
*/
public with sharing class ControllerHelperQC {

    /**
* @description This is a exception class  of no permission 
*/
    public class NoPermissionException extends Exception {}
    
    /**
* @description This method  checks if the Org is connected whit Quality Clouds
*/
    public static Boolean checkIfOrgConnected(){
        String currentOrgId = UserInfo.getOrganizationId();
        Integer orgInstances = [SELECT Count() FROM Instance__c WHERE Inst_Org_Id__c =: currentOrgId];
        return (orgInstances > 0) ? true : false;         
    }
        
    /**
* @description This method get the settings and credentials to connect whit Quality Clouds
*/
    public static QualityCloudsSettings__mdt getSettings(){
        PermissionChecker.exceptionIfNotAccessible(QualityCloudsSettings__mdt.getSObjectType());

        QualityCloudsSettings__mdt  settings;        
        if (settings == null ){
            try{                
                settings = QualityCloudsSettings__mdt.getInstance('APi_Prod');
            }catch (Exception e){
                System.debug(LoggingLevel.Error, e.getStackTraceString()); 
                settings = new QualityCloudsSettings__mdt();                
            }
        }
        return settings;
    }
    
    /**
* @description This method Generates a Random String 
*/
    public static String generateRandomString(Integer stringLength, Boolean allCaps) {
        String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        if (allCaps){
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        }
        String randStr = '';
        while (randStr.length() < stringLength) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
    /**
* @description This method updates the scan fields
*/
    public static boolean updateScannsPolling(Integer pollsLeft){
        boolean done = true;
        List<Scann__c> lstScanToUpd = new  List<Scann__c>();
        List<Scann__c> lstScan = [SELECT  State__c, ID__c, Scan_Type__c, CreatedDate, Id, Quality_Gate_Result__c FROM Scann__c WHERE State__c = 'RUNNING' ORDER BY CreatedDate ASC];
        List<QCIssue__c> fetched_issues = new List<QCIssue__c>();
        List<Tech_DevLog__c> callouts = new List<Tech_DevLog__c>();
        
        if (pollsLeft < 1) {            
            if (Schema.SObjectType.Scann__c.fields.State__c.isUpdateable()){
                for(Scann__c scan : lstScan) {
                    scan.State__c = 'FAIL';                
                }
            }else {
                throw new NoPermissionException('Current user does not have enough permissions to update Scann__c object or its State__c field.');
            }
            if (Schema.sObjectType.Scann__c.isUpdateable()) {
                update lstScan;
            }else {
                throw new NoPermissionException('Current user does not have enough permissions to update Scann__c object.');
            }
            return done;
        }
        
        for(Scann__c scan : lstScan) {
            HttpRequest req = new HttpRequest();
            QualityCloudsSettings__mdt settings = getSettings();
            if (scan.Scan_Type__c == 'feature-branch-scan') {
                req.setEndpoint(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-scan/' + scan.ID__c);
            } else {
                req.setEndpoint(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/scan/' + scan.ID__c);
            }
            req.setMethod('GET');
            req.setHeader('Accept', '*/*');
            req.setHeader('client-name', 'GenericHttpClient');
            req.setHeader('Authorization', 'Bearer ' + getAPIKEY());
            req.setTimeout(120000);
            HTTPResponse res = validateAPIKEY(req);
            if (res.getStatusCode() == 200){
                callouts.add(new Tech_DevLog__c(
                    CalloutAction__c = 'Scan Update', 
                    CalloutRequest__c = req.getBody(), 
                    CalloutResponse__c = 'Status code: ' + res.getStatusCode() + '\n responseBody\n' + res.getBody()));
                jsontoscan.Jsontoscan_c result =  jsontoscan.Jsontoscan_c.parse(res.getBody());
                if (Schema.SObjectType.Scann__c.fields.State__c.isUpdateable()){
                    scan.State__c = result.data.attributes.status;
                }
                if (Schema.SObjectType.Scann__c.fields.Configuration_Elements__c.isUpdateable()){
                    scan.Configuration_Elements__c = result.data.attributes.scanned_configuration_elements;
                }
                if (Schema.SObjectType.Scann__c.fields.Technical_Debt_hours__c.isUpdateable()){
                    scan.Technical_Debt_hours__c = result.data.attributes.technical_debt;
                }
                if (Schema.SObjectType.Scann__c.fields.Quality_of_Cloud__c.isUpdateable()){
                    scan.Quality_of_Cloud__c = result.data.attributes.quality_of_cloud;
                }
                if (Schema.SObjectType.Scann__c.fields.Duration__c.isUpdateable()){
                    scan.Duration__c = result.data.attributes.process_time;
                }
                if (Schema.SObjectType.Scann__c.fields.Total_Issues__c.isUpdateable()){
                    scan.Total_Issues__c = result.data.attributes.number_of_issues;
                }
                if (Schema.SObjectType.Scann__c.fields.Quality_Gate_Result__c.isUpdateable()){
                    scan.Quality_Gate_Result__c = result.data.attributes.quality_gate_result;
                    system.debug('result.data.attributes.quality_gate_result: ' + result.data.attributes.quality_gate_result);
                }
                if (Schema.SObjectType.Scann__c.fields.Quality_Gate_Message__c.isUpdateable()){
                    scan.Quality_Gate_Message__c = result.data.attributes.quality_gate_message; 
                    system.debug(':result.data.attributes.quality_gate_message:' + result.data.attributes.quality_gate_message);
                }        
//to do: Get value from json attribute when done
                if (Schema.SObjectType.Scann__c.fields.AllowCompletionOnFail__c.isUpdateable()){
                    scan.AllowCompletionOnFail__c = true; 
                }  
//end-to do                         
                
                String message_type_out = 'confirm';
                if (result.data.attributes.status == 'SUCCESS') {
                    Integer page = 1, total_pages = 1;

                    do {
                        HttpRequest req2 = new HttpRequest();
                        if (scan.Scan_Type__c == 'feature-branch-scan') {
                            req2.setEndpoint(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-issue?filter[scan_uuid]=' + scan.ID__c + '&page[size]=1000&page[number]=' + page);
                            req2.setMethod('GET');
                            req2.setHeader('Accept', '*/*');
                            req2.setHeader('client-name', 'GenericHttpClient');
                            req2.setHeader('Authorization', 'Bearer ' + getAPIKEY());
                            req2.setTimeout(120000);
                            HTTPResponse res2 = ControllerHelperQC.validateAPIKEY(req2);
                            if (res2.getStatusCode() == 200){
                                
                                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res2.getBody());
                                Map<String, Object> meta_x = (Map<String, Object>) results.get('meta');
                                total_pages = (Integer) meta_x.get('last-page');
                                List< Object> data = (List<Object>) results.get('data');
                                for (Object d : data) {                                        
                                    QCIssue__c issue = ControllerHelperQC.jsonDataToIssue((map<String,Object>) d);
                                    issue.Scan__c = scan.id; 
                                    fetched_issues.add(issue);
                                }                               
                                
                                message_type_out = 'confirm';
                                
                            } else {
                                message_type_out = 'error';
                            }
                        } else {
                            //req2.setEndpoint(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/issue?filter[scan]=' + scan.ID__c + '&page[size]=1000&page[number]=' + page);
                        }
                    } while (message_type_out != 'error' && page++ < total_pages);
                    
                    if (Schema.sObjectType.Scann__c.isUpdateable() && Schema.sObjectType.Scann__c.isAccessible() && scan.Scan_Type__c == 'feature-branch-scan') {
                        scan.Total_Issues__c = fetched_issues.size();
                    }                
                }
                if (result.data.attributes.status == 'RUNNING'){
                    done = false;
                }
                lstScanToUpd.add(scan);
                
            }else {
                done = false;
            }    
        }

        if (Schema.sObjectType.Scann__c.isUpdateable()) {
            update lstScanToUpd;
        }else {
            throw new NoPermissionException('Current user does not have enough permissions to update Scann__c object.');
        }
        if (checkIfUserCanUpsertQCIssue()) {
            upsert fetched_issues ID__c;
        } else {
            throw new NoPermissionException('Current user does not have enough permissions to create/update QCIssue__c object or its fields.');
        }
        if(!callouts.isEmpty()) {
            insert callouts;
        }

        return done;
    } 
    
    /**
* @description This method converts the a string to a DateTime GMT 
*/
    public static Datetime stringToDate(String dateStr){
        if (dateStr != null) {
            Integer year = Integer.ValueOf(dateStr.substring(0, 4));   
            Integer month = Integer.ValueOf(dateStr.substring(5, 7));   
            Integer day = Integer.ValueOf(dateStr.substring(8, 10));  
            Integer hour = Integer.ValueOf(dateStr.substring(11, 13));
            Integer minute = Integer.ValueOf(dateStr.substring(14, 16));
            Integer second = Integer.ValueOf(dateStr.substring(17, 19));
            Integer offset = 0;
            if(dateStr.contains('+') ){
                offset = Integer.ValueOf(dateStr.substringAfterLast('+').substringBeforeLast(':'));
                 hour -= offset;
            } else if(dateStr.lastIndexOf('-') == 19){ //negative offset
                offset = Integer.ValueOf(dateStr.substringAfterLast('-').substringBeforeLast(':'));
                 hour += offset;
            } else {
                Datetime rigthNow = Datetime.now();
                if(isSummerTime(rigthNow)) {
                    hour -= 1;
                }            
            }             
            
            return Datetime.newInstanceGmt(year, month, day, hour, minute, second);
        }
        return null;
    }

    /**
    * @description Return true if datetime is between the last sunday of march 1am and last sunday of october 1am
    */
    private static Boolean isSummerTime(Datetime myDatetime) {
        return lastSundayOf(3) <= myDatetime && myDatetime <= lastSundayOf(10);
    }

    /**
    * @description This method return last sunday of a given month
    */
    private static Datetime lastSundayOf(Integer month) {
        if(month <1 || month > 12){
            return null;
        }
        Time myTime = Time.newInstance(1, 0, 0, 0);
    
        Boolean isSunday = false;
        Integer day = Date.daysInMonth(System.today().year(), month);
        Datetime dt;
        
        while(!isSunday) {
            dt = DateTime.newInstanceGMT(Date.newInstance(System.today().year(), month, day), myTime);
            if(dt.format('EEEE') == 'Sunday')
            {
                isSunday=true; 
            }
            day--;
        }
        return dt;
    }
    /**
* @description This method Serializes the response from Quality Clouds to the fields of QCIssue__c
*/
    public static QCIssue__c jsonDataToIssue(map<String,Object> data){
        Map<String,Object> attributes = (map<String,Object>) data.get('attributes');      

        QCIssue__c issue = new QCIssue__c();
        issue.Created_By__c = (String) attributes.get('created-by'); 
        issue.Updated_On__c = ControllerHelperQC.stringToDate((String) attributes.get('updated-on'));
        issue.Created_On__c = ControllerHelperQC.stringToDate((String) attributes.get('created-on'));
        issue.Updated_By__c =  (String) attributes.get('updated-by'); 
        issue.Severity__c = (String) attributes.get('severity'); 
        issue.Impact_Area__c = (String) attributes.get('impact-area'); 
        issue.Issue__c = (String) attributes.get('issue-type'); 
        issue.Line_Number__c = (Integer) attributes.get('line-number'); 
        issue.Link_to_Element__c = (String) attributes.get('affected-element-sys-id');
        issue.Element_Name__c = (String) attributes.get('affected-element-name'); 
        issue.Element_Type__c = (String) attributes.get('configuration-element-type'); 
        issue.ID__c = (String) data.get('id'); 
        issue.Documentation__c = (String) attributes.get('best-practice-link');
        issue.Baseline__c = (String) attributes.get('reference-status');
        
        //IC QAT-36 Show Quality Gates Breaker in the Quality Clouds App of Salesforce
        if(attributes.get('quality-gate-breaker') != null && attributes.get('quality-gate-breaker') != ''){
            issue.Quality_Gate_Breaker__c = (Boolean) attributes.get('quality-gate-breaker');
        }else{
            issue.Quality_Gate_Breaker__c = false;
        }
        
        map<String,Object> writeoffs = (map<String,Object>) attributes.get('write-off');
        
        String writeOffStatus = (String) writeoffs?.get('write-off-status');
        if (writeOffStatus == 'APPROVED') {
            issue.Write_off__c = true;
        } else {
            issue.Write_off__c = false;
        }
        issue.Write_Off_Requested_Date__c = ControllerHelperQC.stringToDate((String) writeoffs?.get('requested-date'));
        issue.Write_Off_Requester__c = (String) writeoffs?.get('requester');
        issue.Write_Off_Request_Reason__c = (String) writeoffs?.get('request-reason-nameid');
        issue.Write_Off_Request_Description__c = (String) writeoffs?.get('request-description');
        issue.Write_Off_Validation_Date__c = ControllerHelperQC.stringToDate((String) writeoffs?.get('validation-date'));
        issue.Write_Off_Validator__c = (String) writeoffs?.get('validator');
        issue.Write_Off_Validation_Reason__c = (String) writeoffs?.get('validation-reason');
        issue.Write_Off_Status__c = (String) writeoffs?.get('write-off-status');        
        if (issue.Write_Off_Status__c == 'APPROVED' || issue.Write_Off_Status__c == 'EXPIRED') { 
            issue.Write_Off_Expiration_Date__c = ControllerHelperQC.stringToDate((String) writeoffs?.get('expiration-date'))?.date();
        }
        
        //IC QAT-37 new funcionality to show the tags on the issues of the scan.
        Map<String, Map<String, Object>> fullResponseMap = new Map<String, Map<String, Object>>();
        List<Object> objectList = (List<Object>)attributes.get('tags');   
        
        if(objectList != null ){
            for (Integer i = 0; i < objectList.size(); i++) {
                String jsonString = JSON.serialize(objectList[i]);
                Map<String, Object> objectMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
                if (objectMap.get('name') != null) {
                    if(i == 0){
                        issue.TagsMultiPicklist__c = objectMap.get('name').toString();
                    }else{
                        issue.TagsMultiPicklist__c = issue.TagsMultiPicklist__c + ';' + objectMap.get('name').toString();
                    }
                }
            }   
        }
        
        
        return issue;
    }
    
    /**
* @description This method checks is the current user has permisions to modify the QCissue__c fields.
*/
    public static Boolean checkIfUserCanUpsertQCIssue (){
        if (Schema.sObjectType.QCIssue__c.fields.Scan__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Scan__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Created_By__c.isCreateable() 
            && Schema.sObjectType.QCIssue__c.fields.Created_By__c.isUpdateable()  
            && Schema.sObjectType.QCIssue__c.fields.Updated_On__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Updated_On__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Created_On__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Created_On__c.isUpdateable()
            && Schema.sObjectType.QCIssue__c.fields.Updated_By__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Updated_By__c.isUpdateable()
            && Schema.sObjectType.QCIssue__c.fields.Severity__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Severity__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Impact_Area__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Impact_Area__c.isUpdateable()
            && Schema.sObjectType.QCIssue__c.fields.Issue__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Issue__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Line_Number__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Line_Number__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Link_to_Element__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Link_to_Element__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Element_Name__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Element_Name__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Element_Type__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Element_Type__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.ID__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.ID__c.isUpdateable()
            && Schema.sObjectType.QCIssue__c.fields.Documentation__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Documentation__c.isUpdateable()
            && Schema.sObjectType.QCIssue__c.fields.Baseline__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Baseline__c.isUpdateable()
            && Schema.sObjectType.QCIssue__c.fields.Write_Off_Requested_Date__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Write_Off_Requested_Date__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Write_off__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Write_off__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Write_Off_Requester__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Write_Off_Requester__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Write_Off_Request_Reason__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Write_Off_Request_Reason__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Write_Off_Request_Description__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Write_Off_Request_Description__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Write_Off_Validation_Date__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Write_Off_Validation_Date__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Write_Off_Validation_Reason__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Write_Off_Validation_Reason__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Write_Off_Validator__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Write_Off_Validator__c.isUpdateable() 
            && Schema.sObjectType.QCIssue__c.fields.Write_Off_Status__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Write_Off_Status__c.isUpdateable()
            && Schema.sObjectType.QCIssue__c.fields.Quality_Gate_Breaker__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Quality_Gate_Breaker__c.isUpdateable()
            && Schema.sObjectType.QCIssue__c.fields.Write_Off_Expiration_Date__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.Write_Off_Expiration_Date__c.isUpdateable()
            && Schema.sObjectType.QCIssue__c.fields.TagsMultiPicklist__c.isCreateable() && Schema.sObjectType.QCIssue__c.fields.TagsMultiPicklist__c.isUpdateable()                       
            ) {
               return true;
           } else {
               return false;
           }
    }
    
    /**
* @description settup the request and response of the API KEY
*/
    public static HttpResponse accessAPIKEY (String apiKey){
        HttpRequest req = new HttpRequest();
        QualityCloudsSettings__mdt settings = getSettings();
        req.setEndpoint(settings.API_Endpoint__c + '/api/' + settings.API_Version__c + '/user/me');
        req.setMethod('GET');
        req.setHeader('Accept', '*/*');
        req.setHeader('Content-Type','application/vnd.api+json');
        req.setHeader('Client-name', 'Salesforce');
        req.setHeader('Authorization', 'Bearer '+ apiKey);
        HTTPResponse res = validateAPIKEY(req);
        return res;
    }
    
    /**
* @description Get the API KEY of the current user
*/
    public static String getAPIKEY(){
        
        List<QC_User__c> userList = [SELECT QC_Active__c, QC_Valid_Until__c ,API_Key_1__c, API_Key_2__c, API_Key_3__c, API_Key_4__c, API_Key_5__c, API_Key_6__c, API_Key_7__c
                                FROM QC_User__c WHERE User__c =: UserInfo.getUserId() LIMIT 1];
        
        String authorization = null;
        if(userList.size() != 0 && userList[0].API_Key_1__c != null && userList[0].QC_Valid_Until__c > Date.today()){
            authorization = userList[0].API_Key_1__c + userList[0].API_Key_2__c + userList[0].API_Key_3__c + userList[0].API_Key_4__c + userList[0].API_Key_5__c + userList[0].API_Key_6__c + userList[0].API_Key_7__c;                
        }
        
        return authorization;
    }
    
    /**
* @description Validates the access permission of key and handles errors of connection
*/
    public static HTTPResponse validateAPIKEY (HttpRequest request){
        Http http = new Http();
        HTTPResponse response = null;
        
        Integer [] errorList400 = new Integer[]{400,401,402,403,404,405,406};
            Integer [] errorList500 = new Integer[]{500,501,502,503,504,505,506};
                
                try{
                    response = http.send(request);
                    if(errorList400.contains(response.getStatusCode()) && response != null){
                        Throw new CalloutException('Not authorized please check permissions. If problem persists, contact Quality Clouds');
                    }else if(errorList500.contains(response.getStatusCode()) && response != null){
                        Throw new CalloutException('Failed connection. If problem persists, contact Quality Clouds');
                    }
                }catch (Exception e){
                    System.debug('The following exception has occurred: ' + e.getMessage() + e.getCause());  
                }
        
        return response;
    }
    
    /**
* @description This method checks if the current KEY is valid
*/
    public static Boolean checkAPIKEY(){    
        List<QC_User__c> userList = [SELECT Id, Name, User__c, QC_Active__c, QC_Api_Key_Developer__c, QC_Valid_Until__c ,API_Key_1__c, API_Key_2__c, API_Key_3__c, API_Key_4__c, API_Key_5__c, API_Key_6__c, API_Key_7__c
                                FROM QC_User__c WHERE User__c =: UserInfo.getUserId() LIMIT 1];
        
        if(userList.size() != 0 && userList[0].QC_Valid_Until__c != null && userList[0].QC_Valid_Until__c > Date.today() && userList[0].QC_Active__c){
            return true;
        }
        return false;    
    }
}