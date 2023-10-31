@isTest
public class ControllerHelperQCTest {
    @isTest
    static void updateScannsPollingOK() {
        Instance__c instance;
        Instance__c instancee = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);
        upsert instance = instancee ID__c;
        upsert new Scann__c(ID__c= '1',Date__c = Datetime.valueOf('2019-07-23 08:25:59'), State__c='Running', Scan_Type__c='feature-branch-scan', Branch_Name__c='develop', Instance__c= instance.Id) ID__c;
     
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-scan/1','scanok');
        multimock.setStaticResource(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-issue?filter[scan_uuid]=1&page[size]=1000&page[number]=1', 'issuelistok');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the multimock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        Test.startTest();
        boolean testout = ControllerHelperQC.updateScannsPolling(1);
        Scann__c scansAfterUpdate = [SELECT  State__c, ID__c, Scan_Type__c, Id,Quality_Gate_Result__c FROM Scann__c];

        ControllerHelperQC.checkIfOrgConnected();
        ControllerHelperQC.generateRandomString(11,true);
        ControllerHelperQC.stringToDate('2019-07-23 08:25:59');
        ControllerHelperQC.checkIfUserCanUpsertQCIssue();
        List<QCIssue__c> lstIssues = [SELECT ID, TagsMultiPicklist__c FROM QCIssue__c WHERE TagsMultiPicklist__c != NULL];
        Test.stopTest();
        
        System.assertEquals(testout, true);
        System.assertEquals(scansAfterUpdate.State__c, 'SUCCESS');
        System.assertEquals(lstIssues.size(), 1);
        System.assertEquals(lstIssues[0].TagsMultiPicklist__c, 'tag1;tag2;tag3');       
    }
    @isTest
    static void updateScannsPollingNoPollsLeft() {
        Instance__c instance;
        Instance__c instancee = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);
        upsert instance = instancee ID__c;
        upsert new Scann__c(ID__c= '1',Date__c = Datetime.valueOf('2019-07-23 08:25:59'), State__c='Running', Scan_Type__c='feature-branch-scan', Branch_Name__c='develop', Instance__c= instance.Id) ID__c;
        
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-scan/1','scanok');
        multimock.setStaticResource(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-issue?filter[scan_uuid]=1&page[size]=1000&page[number]=1', 'issuelistok');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the multimock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        Test.startTest();
        boolean testout = ControllerHelperQC.updateScannsPolling(0);
        
        Scann__c scansAfterUpdate = [SELECT  State__c, ID__c, Scan_Type__c, Id,Quality_Gate_Result__c FROM Scann__c];
        Test.stopTest();
        
        System.assertEquals(testout, true);
        System.assertEquals(scansAfterUpdate.State__c, 'FAIL');
    }
    
	@isTest
    static void APIKEYMethods() {
        
        ControllerHelperQC.checkAPIKEY();
        ControllerHelperQC.accessAPIKEY('h');
    }
}