/**
* @description Controller Class of ScanDetail page to manage the scan of QualityClouds
*/
public with sharing class ScanDetailController {

    private integer totalRecs = 0;
    private integer index = 0;
    private integer blockSize = 15;

    public string selectedField {get;set;}
    public string selectedDirection {get;set;}
    public string selectedImpact {get;set;}
    public string selectedSeverity {get;set;}
    public string selectedIssue {get;set;}

    public string selectedFieldFin {get;set;}
    public string selectedDirectionFin {get;set;}
    public string selectedImpactFin {get;set;}
    public string selectedSeverityFin {get;set;}
    public string selectedIssueFin {get;set;}


    private string filterWhere {get;set;}

    public String message_type_out{get;set;}
    public String message_out{get;set;}
    public String message{get;set;}
    public String message_type{get;set;}
    public String id_scan = ApexPages.currentPage().getParameters().get('id');
    public String id_instance = ApexPages.currentPage().getParameters().get('id_instance');
    Scann__c scan;
    public boolean showPopup {get;set;}
    public String reason {get;set;}
    public String description {get;set;}


/**
* @description Controller Constructor
*/
    public ScanDetailController() {
        message = ApexPages.currentPage().getParameters().get('message');
        message_type = ApexPages.currentPage().getParameters().get('message_type');
        showPopup = false;
        filterWhere = '';
        selectedField = 'Issue__c';
        selectedDirection = 'ASC';
        selectedImpact = 'ALL';
        selectedSeverity = 'ALL';
        selectedIssue = '';
        selectedFieldFin = 'Quality_Gate_Breaker__c';
        selectedDirectionFin = 'DESC';
        selectedImpactFin = 'ALL';
        selectedSeverityFin = 'ALL';
        selectedIssueFin = '';
        getScan();
        totalRecs = [SELECT count() FROM QCIssue__c WHERE Scan__c = :scan.id];
    }

    public String id_issue{get;set;}

    //public String issue_toupdate{get;set;}
    public String issueIdToUpdate{get;set;}
    public QCIssue__c issueToUpdate{get;set;}


    List<QCIssue__c> issues;
    
            /**
    * @description Get Scan ID variable method
    */
    public String getId_scan(){
        return id_scan;
    }
    
        /**
    * @description Get Scan variable method
    */
    public Scann__c getScan(){
        if (scan == null && Schema.sObjectType.Scann__c.isAccessible())
            scan = [SELECT Branch_Name__c, 
                            Date__c, 
                            Duration__c, 
                            ID__c, 
                            Instance__c, 
                            Scan_Type__c, 
                            Quality_of_Cloud__c, 
                            Configuration_Elements__c, 
                            State__c, 
                            Technical_Debt_hours__c, 
                            Total_Issues__c, 
                            Id, 
                            Quality_Gate_Result__c, 
                            Quality_Gate_Message__c
                            FROM Scann__c 
                            WHERE ID__c = :id_scan 
                            ORDER BY CreatedDate DESC];
        return scan;
    }

    /**
    * @description Get Issues method
    */    
    public List<QCIssue__c> getIssues(){
        if (Schema.sObjectType.QCIssue__c.isAccessible()){
            totalRecs = database.countQuery('SELECT count() FROM QCIssue__c WHERE Scan__c = \'' + scan.id + '\'' + filterWhere);

            issues = database.query('SELECT Link_to_Element__c, Documentation__c, Element_Name__c, ID__c, Impact_Area__c, Issue__c, ' 
                + ' Write_off__c, Baseline__c, Line_Number__c, Severity__c, Id, Write_Off_Request_Description__c,'
                + ' Write_Off_Request_Reason__c, Quality_Gate_Breaker__c, Write_Off_Expiration_Date__c FROM QCIssue__c WHERE Scan__c = \''
                + scan.id + '\'' + filterWhere + ' ORDER BY ' + selectedFieldFin + ' ' + selectedDirectionFin 
                + ', Baseline__c DESC LIMIT ' + blockSize + ' OFFSET ' + index);
        }
        return issues;
    }
    
        /**
    * @description Go Back to Instances
    */   
    public PageReference go_back(){
        PageReference tempPage = new PageReference('/apex/InstanceDetail');
        tempPage.getParameters().put('id', id_instance);
        tempPage.setRedirect(true);
        return tempPage;
    }
    
        /**
    * @description Open Detail page of the Issue
    */   
    public PageReference openDetail(){
        PageReference tempPage = new PageReference('/apex/IssueDetail');
        tempPage.getParameters().put('id', id_issue);
        tempPage.getParameters().put('id_scan', id_scan);
        tempPage.getParameters().put('id_instance', id_instance);
        tempPage.setRedirect(true);
        return tempPage;
    }

    /* public void massiveWriteoff() {

        List<QCIssue__c> issuelisttoupdate = database.query('SELECT Id, Write_off__c FROM QCIssue__c WHERE Scan__c = \'' + scan.id + '\'' + filterWhere);

        for ( QCIssue__c issue : issuelisttoupdate) {
            issue.Write_off__c = true;
        }

        update issuelisttoupdate;

    }
    public void massiveUnWriteoff() {

        List<QCIssue__c> issuelisttoupdate = database.query('SELECT Id, Write_off__c FROM QCIssue__c WHERE Scan__c = \'' + scan.id + '\'' + filterWhere);

        for ( QCIssue__c issue : issuelisttoupdate) {
            issue.Write_off__c = false;
        }

        update issuelisttoupdate;

    }
    public void updateWriteoff() {

        QCIssue__c issuetoupdatefin = [SELECT Id, Write_off__c FROM QCIssue__c WHERE Id = :issue_toupdate];
        issuetoupdatefin.Write_off__c = ! issuetoupdatefin.Write_off__c;
        if (Schema.sObjectType.QCIssue__c.fields.Write_off__c.isUpdateable()){
            update issuetoupdatefin;
        }

    } */

        /**
    * @description Sort the Selected Fields
    */   
    public void sortfilter() {

        selectedFieldFin = selectedField;
        selectedDirectionFin = selectedDirection;
        selectedImpactFin = selectedImpact;
        selectedSeverityFin = selectedSeverity;
        selectedIssueFin = selectedIssue;

        filterWhere = '';

        if( selectedImpactFin != 'All'){
            filterWhere += ' AND Impact_Area__c = \'' + selectedImpactFin + '\'';
        }
        if( selectedSeverityFin != 'All'){
            filterWhere += ' AND Severity__c = \'' + selectedSeverityFin + '\'';
        }
        if( selectedIssueFin != ''){
            filterWhere += ' AND Issue__c like  \'%' + selectedIssueFin + '%\'';
        }

        index = 0;

    }

        /**
    * @description beginning method
    */   
    public void beginning() {

        index = 0;

    }

    /**
    * @description previous page
    */   
    public void previous() {

        index = index - blockSize;

    }
    
    /**
    * @description next page
    */
    public void next() {

        index = index + blockSize;

    }

        /**
    * @description end page
    */
    public void end() {

        index = totalrecs - math.mod(totalRecs,blockSize);

    }

        /**
    * @description getprev page
    */
    public boolean getprev() {
        if(index == 0)
            return true;
        else
            return false;

    }

        /**
    * @description get next page
    */
    public boolean getnxt() {

        if((index + blockSize) > totalRecs)
        return true;
        else
        return false;

    }

        /**
    * @description openPopup Method
    */
    public PageReference openPopup() {
        if (showPopup) {
            return null;
        }
        issueToUpdate = new Map<Id,QCIssue__c>(issues)?.get(issueIdToUpdate);
        System.debug('issueToUpdate ' + issueToUpdate);

        if (issueToUpdate != null) {
            showPopup = true;
        }
        return null;
    }

        /**
    * @description cancel 
    */
    public PageReference cancel() {
        showPopup = false;
        return null;
    }

        /**
    * @description request Write Off of Issue
    */
    public void requestWriteOff() {
        showPopup = false;

        if (issueToUpdate.Write_Off_Request_Reason__c == null && issueToUpdate.Write_off__c == true) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select Request Reason.' ));
            return;
        }
        try {
            HTTPResponse res  = calloutWriteOff();
            if (res.getStatusCode() == 200){
                QCIssue__c issueFromResponse = parseResponse(res.getBody());
                if (ControllerHelperQC.checkIfUserCanUpsertQCIssue()) {
                        upsert issueFromResponse ID__c;
                    } else {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Current user does not have enough permissions to create/update QCIssue__c object or its fields.'));
                    }
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, res.getBody())); 
            }       
            
        } catch (Exception e) {
            System.debug(LoggingLevel.Error, e.getStackTraceString());    
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage() + ', ' + e.getCause()));
        }
    }

        /**
    * @description callout Write Off for the Issue
    */
    private HTTPResponse calloutWriteOff(){
        Map<String, Object> attributes = new Map<String, Object>();

        if (issueToUpdate.Write_off__c == true) {
            attributes.put('write-off-status', 'REQUESTED');
            attributes.put('reason-name-id', issueToUpdate.Write_Off_Request_Reason__c);            
        } else {
            attributes.put('write-off-status', 'DECLINED');
        }
        attributes.put('description', issueToUpdate.Write_Off_Request_Description__c);
        attributes.put('developer', UserInfo.getName());

        Map<String, Object> data = new Map<String, Object>();
        data.put('id', issueToUpdate.ID__c);
        data.put('type', 'feature-branch-issue');
        data.put('attributes', attributes);

        Map<String, Object> jsonObj = new Map<String, Object>();
        jsonObj.put('data', data);

        String jsonStr = JSON.serialize(jsonObj); 

        HttpRequest req = new HttpRequest();
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();
        req.setEndpoint(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-issue/' + issueToUpdate.ID__c);
        req.setMethod('PATCH');
        req.setHeader('Accept', 'application/vnd.api+json');
        req.setHeader('Content-Type', 'application/vnd.api+json');
        req.setHeader('Client-Name', 'Salesforce');
        req.setHeader('Authorization', 'Bearer '+ ControllerHelperQC.getAPIKEY());                
        req.setBody(jsonStr); 
        System.debug('request: '+ req);
        System.debug('request body: '+ req.getBody());   
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('response: '+ res);
        System.debug('response body: '+ res.getBody());     
        return res;
    }

        /**
    * @description parse the Resonse of the Call
    */
    private QCIssue__c parseResponse(String res){
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res);
        Map<String, Object> data = (Map<String, Object>) results.get('data');
        return ControllerHelperQC.jsonDataToIssue(data);        
    }
}