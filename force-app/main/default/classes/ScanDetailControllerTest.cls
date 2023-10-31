@isTest
public class ScanDetailControllerTest {

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
                '"id":"22",'+
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
   
    @IsTest 
    static void givenIssueWriteOffFalse_whenRequestWriteOff_thenIssueWriteOffTrue(){
        Test.setMock(HttpCalloutMock.class, new MockOK());

        Instance__c instance;
        Scann__c scan;
        QCIssue__c issueWOTrue;
        QCIssue__c issueWOFalse;
        upsert instance = new Instance__c(ID__c= '1', Is_Featured_Banch__c=true) ID__c;
        upsert scan = new Scann__c(ID__c= '123',Date__c = Datetime.valueOf('2029-07-23 08:25:59'), State__c='SUCCESS', Scan_Type__c='feature-branch-scan', Branch_Name__c='develop', Instance__c= instance.Id) ID__c;
        upsert issueWOFalse = new QCIssue__c( ID__c='11',  Write_off__c=false, Scan__c =scan.Id) ID__c;
        upsert issueWOTrue = new QCIssue__c( ID__c='22',  Write_off__c=true,  Scan__c =scan.Id) ID__c;
        
        PageReference scanDetailPage = Page.ScanDetail;
        scanDetailPage.getParameters().put('id', scan.ID__c);
        Test.setCurrentPage(scanDetailPage);

        ScanDetailController ctrl = new ScanDetailController();
        ctrl.issueIdToUpdate = issueWOFalse.ID;
        Test.startTest();
        ctrl.getIssues();
        ctrl.openPopup();
        ctrl.issueToUpdate.Write_Off_Request_Reason__c = 'Reason1';
        ctrl.issueToUpdate.Write_off__c = true;
        ctrl.requestWriteOff();
        Test.stopTest();

        Boolean actualWriteOffStatus = [SELECT Write_off__c, ID__c FROM QCIssue__c WHERE ID__c =:issueWOFalse.ID__c ].Write_off__c;
        System.assertEquals(true, actualWriteOffStatus);
    }

    @IsTest 
    static void givenIssueWriteOffTrue_whenRequestWriteOff_thenIssueWriteOffFalse(){
        Test.setMock(HttpCalloutMock.class, new MockOK());

        Instance__c instance;
        Scann__c scan;
        QCIssue__c issueWOTrue;
        QCIssue__c issueWOFalse;
        upsert instance = new Instance__c(ID__c= '1', Is_Featured_Banch__c=true) ID__c;
        upsert scan = new Scann__c(ID__c= '123',Date__c = Datetime.valueOf('2029-07-23 08:25:59'), State__c='SUCCESS', Scan_Type__c='feature-branch-scan', Branch_Name__c='develop', Instance__c= instance.Id) ID__c;
        upsert issueWOFalse = new QCIssue__c( ID__c='11',  Write_off__c=false, Scan__c =scan.Id) ID__c;
        upsert issueWOTrue = new QCIssue__c( ID__c='22',  Write_off__c=true,  Scan__c =scan.Id) ID__c;
        
        PageReference scanDetailPage = Page.ScanDetail;
        scanDetailPage.getParameters().put('id', scan.ID__c);
        Test.setCurrentPage(scanDetailPage);

        ScanDetailController ctrl = new ScanDetailController();
        ctrl.showPopup = false;
        ctrl.issueIdToUpdate = issueWOTrue.ID;
        Test.startTest();
        ctrl.getIssues();
        ctrl.openPopup();
        ctrl.issueToUpdate.Write_Off_Request_Reason__c = 'Reason1';
        ctrl.issueToUpdate.Write_off__c = false;
        ctrl.requestWriteOff();
        Test.stopTest();

        Boolean actualWriteOffStatus = [SELECT Write_off__c, ID__c FROM QCIssue__c WHERE ID__c =:issueWOTrue.ID__c ].Write_off__c;
        System.assertEquals(false, actualWriteOffStatus);
    }
}