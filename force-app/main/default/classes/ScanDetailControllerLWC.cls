/**
 * @description       : Controller class for lwc scan detail
 * @author            : Fran Mejías
 * @group             : 
 * @last modified on  : 23-06-2023
 * @last modified by  : Fran Mejías
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   23-06-2023   Fran Mejías   Initial Version
**/
public with sharing class ScanDetailControllerLWC {

    /**
    * @description Retrieve all the issues without any filter
    */
    @AuraEnabled
    public static List<issueWrapper> getAllIssues(String scanId) {

        List<issueWrapper> result = new List<issueWrapper>();
        
        for(QCIssue__c issue : [SELECT Id, ID__c, Issue__c, Severity__c, Impact_Area__c, Element_Name__c, Line_Number__c, Link_to_Element__c, Documentation__c, Quality_Gate_Breaker__c,  
                                     Write_Off_Requested_Date__c, Write_Off_Validation_Date__c, Write_Off_Validation_Reason__c, Write_Off_Validator__c, Write_Off_Expiration_Date__c  
                                FROM QCIssue__c WHERE Scan__c = :scanId]) {
            
            issueWrapper wrap = new issueWrapper();

            wrap.issueId = issue.Id;
            wrap.issue = issue.Issue__c;
            wrap.severity = issue.Severity__c;
            wrap.area = issue.Impact_Area__c;
            wrap.element = issue.Element_Name__c;
            wrap.line = String.valueOf(issue.Line_Number__c);
            wrap.linkElement = issue.Link_to_Element__c;
            wrap.doc = issue.Documentation__c;
            wrap.type = issue.Quality_Gate_Breaker__c == true ? 'BLOCKER' : 'MINOR';
            wrap.woDate = issue.Write_Off_Requested_Date__c;
            wrap.woValDate = issue.Write_Off_Validation_Date__c?.format();
            wrap.woValReason = issue.Write_Off_Validation_Reason__c;
            wrap.woValidator = issue.Write_Off_Validator__c;
            wrap.woExpDate  = issue.Write_Off_Expiration_Date__c?.format();
            wrap.IDC = issue.ID__c;

            result.add(wrap);
        }            

        return result;
    }


    /**
    * @description Retrieve the issues related to a Scan acording to the pagination and filters
    */
    @AuraEnabled
    public static issuesPaginationWrapper getIssues(String scanId, String impact, String severity, String filter, Boolean closedWO, Integer pageSize, Integer pageNumber) {
        Schema.DescribeSObjectResult dsr = QCIssue__c.sObjectType.getDescribe();
        String namespacePrefix = dsr.getName().remove(dsr.getLocalName());

        issuesPaginationWrapper result = new issuesPaginationWrapper();
                    
        String filterWhere='';

        if( impact != 'All'){
            filterWhere += ' AND ' + namespacePrefix + 'Impact_Area__c = \'' + impact + '\'';
        }
        if( severity != 'All'){
            filterWhere += ' AND ' + namespacePrefix + 'Severity__c = \'' + severity + '\'';
        }
        if(filter != ''){
            filterWhere += ' AND ' + namespacePrefix + 'Issue__c like  \'%' + filter + '%\'';
        }

        Integer offset = (pageNumber - 1) * pageSize;  
        Integer recordEnd = pageSize * pageNumber;

        String queryCount; 

        queryCount = 'SELECT COUNT() FROM ' + namespacePrefix + 'QCIssue__c WHERE ' + namespacePrefix + 'Scan__c = \'' + scanId + '\' AND ' + namespacePrefix + 'Write_off__c = ' + closedWO + filterWhere;

        Integer totalRecords = database.countQuery(queryCount);

        result.recordStart  = offset + 1;
        result.pageNumber = pageNumber;
        result.totalRecords = totalRecords;
        result.recordEnd =  totalRecords >= recordEnd ? recordEnd : totalRecords;
        result.pageSize = pageSize;

        List<QCIssue__c> lstIssues = new List<QCIssue__c>();
        String query; 

        query = 'SELECT Id, ' + namespacePrefix + 'ID__c, ' + namespacePrefix + 'Issue__c, ' + namespacePrefix + 'Severity__c, ' + namespacePrefix + 'Impact_Area__c, ' + namespacePrefix + 'Element_Name__c, ' + namespacePrefix + 'Line_Number__c, ' + namespacePrefix + 'Link_to_Element__c, ' + namespacePrefix + 'Documentation__c, ' + namespacePrefix + 'Quality_Gate_Breaker__c, ' + 
        ' ' + namespacePrefix + 'Write_Off_Requested_Date__c, ' + namespacePrefix + 'Write_Off_Validation_Date__c, ' + namespacePrefix + 'Write_Off_Validation_Reason__c, ' + namespacePrefix + 'Write_Off_Validator__c, ' + namespacePrefix + 'Write_Off_Expiration_Date__c ' + 
        ' FROM ' + namespacePrefix + 'QCIssue__c WHERE ' + namespacePrefix + 'Scan__c = \'' + scanId + '\' AND ' + namespacePrefix + 'Write_off__c = ' + closedWO + filterWhere + ' LIMIT ' + pageSize + ' OFFSET ' + offset;

        lstIssues = database.query(query);

        for(QCIssue__c issue : lstIssues) {
            issueWrapper wrap = new issueWrapper();

            wrap.issueId = issue.Id;
            wrap.issue = issue.Issue__c;
            wrap.severity = issue.Severity__c;
            wrap.area = issue.Impact_Area__c;
            wrap.element = issue.Element_Name__c;
            wrap.line = String.valueOf(issue.Line_Number__c);
            wrap.linkElement = issue.Link_to_Element__c;
            wrap.doc = issue.Documentation__c;
            wrap.type = issue.Quality_Gate_Breaker__c == true ? 'BLOCKER' : 'MINOR';
            wrap.woDate = issue.Write_Off_Requested_Date__c;
            wrap.woValDate = issue.Write_Off_Validation_Date__c?.format();
            wrap.woValReason = issue.Write_Off_Validation_Reason__c;
            wrap.woValidator = issue.Write_Off_Validator__c;
            wrap.woExpDate  = issue.Write_Off_Expiration_Date__c?.format();
            wrap.IDC = issue.ID__c;

            result.issues.add(wrap);
        }            

        return result;
    }

    /**
    * @description callout to cancel a Write Off for the Issue
    */
    @AuraEnabled
    public static Map<String,Object> cancelWriteOff(String issueId, String idc) {        
        QCIssue__c issue = new QCIssue__c(); 
        issue.Id= issueId;
        issue.ID__c = idc;   

        HTTPResponse res  = calloutWriteOff(issue, 'cancelled');
        return getResponse(res, 'cancelled');
    }

        /**
    * @description callout to send a Write Off for the Issue
    */
    @AuraEnabled
    public static Map<String,Object> sendWriteOff(String issueId, String idc, String reason, String description) {        
        QCIssue__c issue = new QCIssue__c(); 
        issue.Id= issueId;
        issue.ID__c = idc;   
        issue.Write_Off_Request_Reason__c= reason;
        issue.Write_Off_Request_Description__c = description;          

        HTTPResponse res  = calloutWriteOff(issue, 'requested');
        return getResponse(res, 'requested');
    }

    private static HTTPResponse calloutWriteOff(QCIssue__c issue, String action)
    {
        Map<String, Object> attributes = new Map<String, Object>();

        if (action == 'requested') {
            attributes.put('write-off-status', 'REQUESTED');
            attributes.put('reason-name-id', issue.Write_Off_Request_Reason__c);            
        } else {
            attributes.put('write-off-status', 'DECLINED');
        }
        attributes.put('description', issue.Write_Off_Request_Description__c);
        attributes.put('developer', UserInfo.getName());

        Map<String, Object> data = new Map<String, Object>();
        data.put('id', issue.ID__c);
        data.put('type', 'feature-branch-issue');
        data.put('attributes', attributes);

        Map<String, Object> jsonObj = new Map<String, Object>();
        jsonObj.put('data', data);

        String jsonStr = JSON.serialize(jsonObj); 

        HttpRequest req = new HttpRequest();
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();
        req.setEndpoint(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-issue/' + issue.ID__c);
        req.setMethod('PATCH');
        req.setHeader('Accept', 'application/vnd.api+json');
        req.setHeader('Content-Type', 'application/vnd.api+json');
        req.setHeader('Client-Name', 'Salesforce');
        req.setHeader('Authorization', 'Bearer '+ ControllerHelperQC.getAPIKEY());                
        req.setBody(jsonStr); 
        Http http = new Http();
        System.debug('request: '+ req);
        System.debug('request body: '+ req.getBody());
        HTTPResponse res = http.send(req);  
        return res;
    }
    
    private static Map<String,Object> getResponse(HTTPResponse res, String action ) {
        Map<String,Object> result = new Map<String,Object>();

        try {
            if (res.getStatusCode() == 200){
                QCIssue__c issueFromResponse = parseResponse(res.getBody());
                if (ControllerHelperQC.checkIfUserCanUpsertQCIssue()) {
                    if(action == 'cancelled') {
                        issueFromResponse.Write_Off_Request_Description__c = null;  
                        issueFromResponse.Write_Off_Request_Reason__c = null;  	
                        issueFromResponse.Write_Off_Requested_Date__c = null;  	
                        issueFromResponse.Write_Off_Requester__c = null;  		
                        issueFromResponse.Write_Off_Validation_Date__c = null;  	
                        issueFromResponse.Write_Off_Validation_Reason__c = null;  	
                        issueFromResponse.Write_Off_Validator__c = null;   
                    }
                    upsert issueFromResponse ID__c;
                    result.put('isSuccess', 'OK');
                    result.put('message', 'Write off ' + action + ' successfully');
                } else {
                    result.put('isSuccess', 'KO');
                    result.put('message', 'Current user does not have enough permissions to create/update QCIssue__c object or its fields.');
                }
            } else {
                result.put('isSuccess', 'KO');
                result.put('message', res.getBody().substringAfter('"title":').remove('}').remove(']')); 
            }       
            
        } catch (Exception e) {
            result.put('isSuccess', 'KO');
            result.put('message', e.getMessage() + ', ' + e.getCause());
        }

        return result;
    }

    /**
    * @description parse the Resonse of the Call
    */
    private static QCIssue__c parseResponse(String res){
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res);
        Map<String, Object> data = (Map<String, Object>) results.get('data');
        return ControllerHelperQC.jsonDataToIssue(data);        
    }

    private static AuraHandledException newException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }        

    /**
    * @description Retrieve severities filtered by area
    */
    @AuraEnabled
    public static Map<String,String> getSeverities(String scanId, String impact, String filter, Boolean closedWO ) {        

        Schema.DescribeFieldResult dfr = QCIssue__c.sObjectType.fields.Impact_Area__c.getDescribe();
        String namespacePrefix = dfr.getName().remove(dfr.getLocalName());

        Map<String,String> result = new Map<String,String>();
        
        String filterWhere='';
        
        if( impact != 'All'){
            filterWhere += ' AND ' + namespacePrefix + 'Impact_Area__c = \'' + impact + '\'';
        }
        if(filter != ''){
            filterWhere += ' AND ' + namespacePrefix + 'Issue__c like  \'%' + filter + '%\'';
        }

        String query = 'SELECT ' + namespacePrefix + 'severity__c FROM ' + namespacePrefix + 'QCIssue__c WHERE ' + namespacePrefix + 'Scan__c = \'' + scanId + '\' AND ' + namespacePrefix + 'Write_off__c = ' + closedWO + filterWhere + ' GROUP BY ' + namespacePrefix + 'severity__c';

        AggregateResult[] groupedResults = database.query(query);
        
        result.put('ALL SEVERITIES', 'all');
                
        for (AggregateResult ar : groupedResults)  {        
            switch on String.Valueof(ar.get('severity__c')) {
                when 'HIGH' {
                    result.put('HIGH', 'high');
                }
                when 'MEDIUM' {
                    result.put('MEDIUM', 'med');
                }
                when 'LOW' {
                    result.put('LOW', 'low');
                }
                when 'WARNING' {
                    result.put('WARNING', 'warn');
                }
            }
        }

        return result;
    }
    /**
    * @description Retrieve areas filtered by severities
    */
    @AuraEnabled
    public static Map<String,String> getAreas(String scanId, String severity, String filter, Boolean closedWO ) {        
        
        Schema.DescribeSObjectResult dsr = QCIssue__c.sObjectType.getDescribe();
        String namespacePrefix = dsr.getName().remove(dsr.getLocalName());

        Map<String,String> result = new Map<String,String>();
        
        String filterWhere='';
        
        if( severity != 'All'){
            filterWhere += ' AND ' + namespacePrefix + 'Severity__c = \'' + severity + '\'';
        }
        if(filter != ''){
            filterWhere += ' AND ' + namespacePrefix + 'Issue__c like  \'%' + filter + '%\'';
        }

        String query = 'SELECT ' + namespacePrefix + 'Impact_Area__c FROM ' + namespacePrefix + 'QCIssue__c WHERE ' + namespacePrefix + 'Scan__c = \'' + scanId + '\' AND ' + namespacePrefix + 'Write_off__c = ' + closedWO + filterWhere + ' GROUP BY ' + namespacePrefix + 'Impact_Area__c';

        AggregateResult[] groupedResults = database.query(query);

        result.put('ALL IMPACT AREAS', 'all');        
        
        for (AggregateResult ar : groupedResults)  {        
            switch on String.Valueof(ar.get(namespacePrefix + 'Impact_Area__c')) {
                when 'SECURITY' {
                    result.put('SECURITY', 'security');
                }
                when 'MANAGEABILITY' {
                    result.put('MANAGEABILITY', 'manage');
                }
                when 'PERFORMANCE' {
                    result.put('PERFORMANCE', 'perform');
                }
                when 'SCALABILITY' {
                    result.put('SCALABILITY', 'escal');
                }
            }
        }

        return result;
    }

    
    /**
    * @description Retrieve severities without filters
    */
    @AuraEnabled
    public static Map<String,String> getAllSeverities(String scanId, Boolean closedWO ) {        
        
        Schema.DescribeSObjectResult dsr = QCIssue__c.sObjectType.getDescribe();
        String namespacePrefix = dsr.getName().remove(dsr.getLocalName());

        Map<String,String> result = new Map<String,String>();        

        String query = 'SELECT ' + namespacePrefix + 'severity__c FROM ' + namespacePrefix + 'QCIssue__c WHERE ' + namespacePrefix + 'Scan__c = \'' + scanId + '\' AND ' + namespacePrefix + 'Write_off__c = ' + closedWO + ' GROUP BY ' + namespacePrefix + 'severity__c';

        AggregateResult[] groupedResults = database.query(query);
        
        result.put('ALL SEVERITIES', 'all');        
        
        for (AggregateResult ar : groupedResults)  {        
            switch on String.Valueof(ar.get(namespacePrefix + 'severity__c')) {
                when 'HIGH' {
                    result.put('HIGH', 'high');
                }
                when 'MEDIUM' {
                    result.put('MEDIUM', 'med');
                }
                when 'LOW' {
                    result.put('LOW', 'low');
                }
                when 'WARNING' {
                    result.put('WARNING', 'warn');
                }
            }
        }

        return result;
    }

    /**
    * @description Retrieve areas without filters
    */
    @AuraEnabled
    public static Map<String,String> getAllAreas(String scanId, Boolean closedWO ) {        

        Schema.DescribeSObjectResult dsr = QCIssue__c.sObjectType.getDescribe();
        String namespacePrefix = dsr.getName().remove(dsr.getLocalName());

        Map<String,String> result = new Map<String,String>();

        String query = 'SELECT ' + namespacePrefix + 'Impact_Area__c FROM ' + namespacePrefix + 'QCIssue__c WHERE ' + namespacePrefix + 'Scan__c = \'' + scanId + '\' AND ' + namespacePrefix + 'Write_off__c = ' + closedWO + ' GROUP BY ' + namespacePrefix + 'Impact_Area__c';

        AggregateResult[] groupedResults = database.query(query);

        result.put('ALL IMPACT AREAS', 'all');

        for (AggregateResult ar : groupedResults)  {        
            switch on String.Valueof(ar.get(namespacePrefix + 'Impact_Area__c')) {
                when 'SECURITY' {
                    result.put('SECURITY', 'security');
                }
                when 'MANAGEABILITY' {
                    result.put('MANAGEABILITY', 'manage');
                }
                when 'PERFORMANCE' {
                    result.put('PERFORMANCE', 'perform');
                }
                when 'SCALABILITY' {
                    result.put('SCALABILITY', 'escal');
                }
            }
        }

        return result;
    }

    public class issuesPaginationWrapper {
        @AuraEnabled public Integer recordStart {get;set;}
        @AuraEnabled public Integer pageNumber {get;set;}
        @AuraEnabled public Integer totalRecords {get;set;}
        @AuraEnabled public Integer recordEnd {get;set;}
        @AuraEnabled public Integer pageSize {get;set;}       
        @AuraEnabled public List<issueWrapper> issues {get;set;}

        public issuesPaginationWrapper()
        {
            this.issues = new list<issueWrapper>();
        }
    }

    public class issueWrapper {
        @AuraEnabled public String issueId {get;set;}
        @AuraEnabled public String issue {get;set;}
        @AuraEnabled public String severity {get;set;}
        @AuraEnabled public String area {get;set;}
        @AuraEnabled public String element {get;set;}
        @AuraEnabled public String line {get;set;}
        @AuraEnabled public String linkElement {get;set;}
        @AuraEnabled public String doc {get;set;}
        @AuraEnabled public String type {get;set;}
        @AuraEnabled public DateTime woDate {get;set;}
        @AuraEnabled public String IDC {get;set;}
        @AuraEnabled public String woValDate {get;set;}
        @AuraEnabled public String woValReason {get;set;}
        @AuraEnabled public String woValidator {get;set;}
        @AuraEnabled public String woExpDate {get;set;} 
    }
}