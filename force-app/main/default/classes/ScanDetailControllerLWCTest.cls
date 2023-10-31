/**
 * @description       : Test for ScanDetailControllerLWC class
 * @author            : Fran Mejías
 * @group             : 
 * @last modified on  : 23-06-2023
 * @last modified by  : Fran Mejías
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   23-06-2023   Fran Mejías   Initial Version
**/
@isTest
public with sharing class ScanDetailControllerLWCTest {

    private class MockOK implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getBody().contains('"write-off-status":"REQUESTED"')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"data":{"type":"feature-branch-issue","id":"11",'+
                '"attributes":{"scan-uuid":"6faff0ad-4ea9-4ab9-8eb4-a14ab169f46f",'+
                '"affected-element-sys-id":"https://github/17be096d/Trg_Opportunity.trigger",'+
                '"affected-element-name":"Trg_Opportunity",'+
                '"created-by":"Andrei Jicol <ajicol@qc.com>",'+
                '"created-on":"2021-03-19 10:08:00",'+
                '"updated-by":"Andrei Jicol <ajicol@qc.com>",'+
                '"updated-on":"2021-03-19 10:08:00",'+
                '"severity":"MEDIUM",'+
                '"impact-area":"MANAGEABILITY",'+
                '"issue-type":"Avoid excessive cyclomatic complexity.",'+
                '"line-number":8,'+
                '"best-practice-link":"https://docs.qualityclouds.com/CyclomaticComplexity",'+
                '"configuration-element-type":"Apex Trigger",'+
                '"reference-status":"NEW",'+
                '"write-off":{"write-off-status":"APPROVED",'+
                '"write-off-date":"2021-08-19 14:09:23",'+
                '"requested-date":"2021-08-19 14:09:23",'+
                '"request-reason":"Insufficient time to fix and test",'+
                '"request-reason-nameid":"Reason2",'+
                '"requester":"Andrei Jicol",'+
                '"validator":"Andrei Jicol",'+
                '"validation-reason":"write off descr1",'+
                '"request-description":"write off descr1",'+
                '"validation-date":"2021-08-19 14:09:23"}},'+
                '"links":{"self":"http://services-development.qualityclouds.com/api/v2/feature-branch-issue/106149"}}}');
                res.setStatusCode(200);
                return res;
            } else if (req.getBody().contains('"write-off-status":"DECLINED"')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"data":{"type":"feature-branch-issue",'+
                '"id":"11",'+
                '"attributes":{"scan-uuid":"6faff0ad-4ea9-4ab9-8eb4-a14ab169f46f",'+
                '"affected-element-sys-id":"https://github/17beeFirstAndLastCampaigns.trigger",'+
                '"affected-element-name":"UpdateFirstAndLastCampaigns",'+
                '"created-by":"Andrei Jicol <ajicol@qc.com>",'+
                '"created-on":"2021-03-19 10:08:00",'+
                '"updated-by":"Andrei Jicol <ajicol@qc.com>",'+
                '"updated-on":"2021-03-19 10:08:00",'+
                '"severity":"MEDIUM",'+
                '"impact-area":"MANAGEABILITY",'+
                '"issue-type":"Access permissions peration.",'+
                '"line-number":62,'+
                '"best-practice-link":"https://docs.qualityclouds.com/qcd/acon-31720331.html",'+
                '"configuration-element-type":"Apex Trigger",'+
                '"reference-status":"BASELINE",'+
                '"write-off":{"write-off-status":"DECLINED",'+
                '"write-off-date":"2021-08-19 14:07:12",'+
                '"requested-date":"2021-08-17 15:52:19",'+
                '"request-reason":"Insufficient time to fix and test",'+
                '"request-reason-nameid":"Reason2",'+
                '"requester":"ajicol@qualityclouds.com",'+
                '"validator":"Andrei Jicol",'+
                '"validation-reason":"qqqqqwww2",'+
                '"request-description":"qqqqqwww",'+
                '"validation-date":"2021-08-19 14:07:12"}},'+
                '"links":{"self":"http://services-development.qualityclouds.com/api/v2/feature-branch-issue/106174"}}}');
                res.setStatusCode(200);
                return res;
            } else {
                System.assert(false, 'unexpected request body ' + req.getBody());
                return null;
            }
        }
    }

    @isTest
    static void getAllIssuesTest(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;

        Scann__c scan = new Scann__c(Date__c = Date.today(), State__c = 'SUCCESS', ID__c = '1', Scan_Type__c = 'feature-branch-scan', Branch_Name__c = 'DUMMY', Instance__c = myInstance.Id) ;

        insert scan;
        
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        QCIssue__c issue = new QCIssue__c( ID__c='11',  Write_off__c=false, Scan__c =scan.Id, Issue__c = 'Avoid something', Impact_Area__c = 'SECURITY', Severity__c = 'HIGH' );

        insert issue;

        Test.startTest();

        List<ScanDetailControllerLWC.issueWrapper> response = new List<ScanDetailControllerLWC.issueWrapper>();

        response = ScanDetailControllerLWC.getAllIssues(scan.Id); 
        Test.stopTest();

        System.assertEquals(1, response.size());
    }  
    
    @isTest
    static void getIssuesTest(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;

        Scann__c scan = new Scann__c(Date__c = Date.today(), State__c = 'SUCCESS', ID__c = '1', Scan_Type__c = 'feature-branch-scan', Branch_Name__c = 'DUMMY', Instance__c = myInstance.Id) ;

        insert scan;
        
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        QCIssue__c issue = new QCIssue__c( ID__c='11',  Write_off__c=false, Scan__c =scan.Id, Issue__c = 'Avoid something', Impact_Area__c = 'SECURITY', Severity__c = 'HIGH' );

        insert issue;

        Test.startTest();
       
        ScanDetailControllerLWC.issuesPaginationWrapper result = ScanDetailControllerLWC.getIssues(scan.Id, 'SECURITY', 'HIGH', '', false, 1, 1); 
        Test.stopTest();

        System.assertEquals(1, result.issues.size());
    }  

    @isTest
    static void sendWriteOff(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;

        Scann__c scan = new Scann__c(Date__c = Date.today(), State__c = 'SUCCESS', ID__c = '1', Scan_Type__c = 'feature-branch-scan', Branch_Name__c = 'DUMMY', Instance__c = myInstance.Id) ;

        insert scan;
        
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        QCIssue__c issue = new QCIssue__c( ID__c='11',  Write_off__c=false, Scan__c =scan.Id, Issue__c = 'Avoid something', Impact_Area__c = 'SECURITY', Severity__c = 'HIGH' );

        insert issue;

        Test.setMock(HttpCalloutMock.class, new MockOK());
        Test.startTest();

        Map<String,Object> response = new Map<String,Object>();

        response = ScanDetailControllerLWC.sendWriteOff(issue.Id, '11', 'reason', 'description'); 
        QCIssue__c issueAfter = [SELECT Write_Off_Request_Description__c, Write_off__c  FROM QCIssue__c];

        Test.stopTest();

        System.assertEquals('OK', response.get('isSuccess'));
        System.assertEquals(true, issueAfter.Write_off__c );

    }    

    @isTest
    static void cancelWriteOff(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;

        Scann__c scan = new Scann__c(Date__c = Date.today(), State__c = 'SUCCESS', ID__c = '1', Scan_Type__c = 'feature-branch-scan', Branch_Name__c = 'DUMMY', Instance__c = myInstance.Id) ;

        insert scan;
        
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        QCIssue__c issue = new QCIssue__c( ID__c='11',  Write_off__c=false, Scan__c =scan.Id, Issue__c = 'Avoid something', Impact_Area__c = 'SECURITY', Severity__c = 'HIGH' );

        insert issue;

        Test.setMock(HttpCalloutMock.class, new MockOK());
        Test.startTest();

        Map<String,Object> response = new Map<String,Object>();

        response = ScanDetailControllerLWC.cancelWriteOff(issue.Id, '11'); 
        QCIssue__c issueAfter = [SELECT Write_Off_Request_Description__c, Write_off__c  FROM QCIssue__c];

        Test.stopTest();

        System.assertEquals('OK', response.get('isSuccess'));
        System.assertEquals(false, issueAfter.Write_off__c );
        System.assertEquals(null, issueAfter.Write_Off_Request_Description__c );
    }    

    @isTest
    static void getSeveritiesTest(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;

        Scann__c scan = new Scann__c(Date__c = Date.today(), State__c = 'SUCCESS', ID__c = '1', Scan_Type__c = 'feature-branch-scan', Branch_Name__c = 'DUMMY', Instance__c = myInstance.Id) ;

        insert scan;
        
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        QCIssue__c issue = new QCIssue__c( ID__c='11',  Write_off__c=false, Scan__c =scan.Id, Issue__c = 'Avoid something', Impact_Area__c = 'SECURITY', Severity__c = 'HIGH' );

        insert issue;

        Test.startTest();
        
        Map<String,String> result = ScanDetailControllerLWC.getSeverities(scan.Id, 'SECURITY', '', false); 
        Test.stopTest();

        System.assertEquals(2, result.keySet().size());
        System.assertEquals(true, result.containsKey('HIGH'));
        System.assertEquals(true, result.containsKey('ALL SEVERITIES'));
        System.assertEquals(false, result.containsKey('LOW'));
    }  

    @isTest
    static void getAreasTest(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;

        Scann__c scan = new Scann__c(Date__c = Date.today(), State__c = 'SUCCESS', ID__c = '1', Scan_Type__c = 'feature-branch-scan', Branch_Name__c = 'DUMMY', Instance__c = myInstance.Id) ;

        insert scan;
        
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        QCIssue__c issue = new QCIssue__c( ID__c='11',  Write_off__c=false, Scan__c =scan.Id, Issue__c = 'Avoid something', Impact_Area__c = 'SECURITY', Severity__c = 'HIGH' );

        insert issue;

        Test.startTest();
        
        Map<String,String> result = ScanDetailControllerLWC.getAreas(scan.Id, 'HIGH', '',  false); 
        Test.stopTest();

        System.assertEquals(2, result.keySet().size());
        System.assertEquals(true, result.containsKey('SECURITY'));
        System.assertEquals(true, result.containsKey('ALL IMPACT AREAS'));
        System.assertEquals(false, result.containsKey('MANEGABILITY'));
    }  

    @isTest
    static void getAllSeveritiesTest(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;

        Scann__c scan = new Scann__c(Date__c = Date.today(), State__c = 'SUCCESS', ID__c = '1', Scan_Type__c = 'feature-branch-scan', Branch_Name__c = 'DUMMY', Instance__c = myInstance.Id) ;

        insert scan;
        
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        QCIssue__c issue = new QCIssue__c( ID__c='11',  Write_off__c=false, Scan__c =scan.Id, Issue__c = 'Avoid something', Impact_Area__c = 'SECURITY', Severity__c = 'HIGH' );

        insert issue;

        Test.startTest();
        
        Map<String,String> result = ScanDetailControllerLWC.getAllSeverities(scan.Id, false); 
        Test.stopTest();

        System.assertEquals(2, result.keySet().size());
        System.assertEquals(true, result.containsKey('HIGH'));
        System.assertEquals(true, result.containsKey('ALL SEVERITIES'));
        System.assertEquals(false, result.containsKey('LOW'));        
    }  

    @isTest
    static void getAllAreasTest(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;

        Scann__c scan = new Scann__c(Date__c = Date.today(), State__c = 'SUCCESS', ID__c = '1', Scan_Type__c = 'feature-branch-scan', Branch_Name__c = 'DUMMY', Instance__c = myInstance.Id) ;

        insert scan;
        
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        QCIssue__c issue = new QCIssue__c( ID__c='11',  Write_off__c=false, Scan__c =scan.Id, Issue__c = 'Avoid something', Impact_Area__c = 'SECURITY', Severity__c = 'HIGH' );

        insert issue;

        Test.startTest();
        
        Map<String,String> result = ScanDetailControllerLWC.getAllAreas(scan.Id, false); 
        Test.stopTest();

        System.assertEquals(2, result.keySet().size());
        System.assertEquals(true, result.containsKey('SECURITY'));
        System.assertEquals(true, result.containsKey('ALL IMPACT AREAS'));
        System.assertEquals(false, result.containsKey('MANEGABILITY'));

    }      
}