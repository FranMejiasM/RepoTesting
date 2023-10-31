/**
 * @description       : Test class for InstanceDetailControllerLWC
 * @author            : Fran Mejías
 * @group             : 
 * @last modified on  : 22-06-2023
 * @last modified by  : Fran Mejías
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   22-06-2023   Fran Mejías   Initial Version
**/
@isTest
public with sharing class InstanceDetailControllerLWCTest {

    @isTest
    static void executeScanTest(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('scanok');
        mock.setStatusCode(202);
        mock.setHeader('Content-Type', 'application/json');

        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        Map<String,Object> response = new Map<String,Object>();
        response = InstanceDetailControllerLWC.executeScan(myInstance.Id, '1', 'dummy'); 
        Test.stopTest();

        System.assertEquals('OK', response.get('isSuccess'));
        System.assertEquals('Scan launched.', response.get('message'));
        System.assertEquals([select Id FROM Scann__c].size(), 1);

    } 

    @isTest
    static void executeScanDelayTest(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;

        insert new Scann__c(Date__c = Date.today(), State__c = 'RUNNING', ID__c = '1', Scan_Type__c = 'feature-branch-scan', Branch_Name__c = 'DUMMY', Instance__c = myInstance.Id) ;
        
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-scan/1','scandelay');
        multimock.setStaticResource(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-issue?filter[scan_uuid]=1&page[size]=1000&page[number]=1', 'issuelistok');
        multimock.setStatusCode(200);

        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        Test.startTest();
        Map<String,Object> response = new Map<String,Object>();
        response = InstanceDetailControllerLWC.executeScan(myInstance.Id, '1', 'dummy'); 
        Test.stopTest();

        System.assertEquals('WARN', response.get('isSuccess'));
        System.assertEquals('There are to many scans running on the same branch, please try again later.', response.get('message'));
        System.assertEquals([select Id FROM Scann__c].size(), 1);

    } 

    @isTest
    static void executeScanErrorTest(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;
 
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('scanok');
        mock.setStatusCode(203);
        mock.setHeader('Content-Type', 'application/json');

        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        Map<String,Object> response = new Map<String,Object>();
        response = InstanceDetailControllerLWC.executeScan(myInstance.Id, '1', 'dummy'); 
        Test.stopTest();

        System.assertEquals('ERR', response.get('isSuccess'));
        System.assertEquals('We could not run the scan. Please contact your administrator.', response.get('message'));
        System.assertEquals([select Id FROM Scann__c].size(), 0);

    } 

    @isTest
    static void getScansTest(){

        Instance__c myInstance = new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true);

        insert myInstance;
system.debug('1');
      insert new Scann__c(Date__c = Date.today(), State__c = 'RUNNING', ID__c = '1', Scan_Type__c = 'feature-branch-scan', Branch_Name__c = 'DUMMY', Instance__c = myInstance.Id) ;
      QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();

      MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
      multimock.setStaticResource(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-scan/1','scanok');
      multimock.setStaticResource(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/feature-branch-issue?filter[scan_uuid]=1&page[size]=1000&page[number]=1', 'issuelistok');
      multimock.setStatusCode(200);

      // Set the multimock callout mode
      Test.setMock(HttpCalloutMock.class, multimock);

        system.debug('2');
        
        Test.startTest();

        List<InstanceDetailControllerLWC.scanWrapper> scans = new List<InstanceDetailControllerLWC.scanWrapper>();
        system.debug('3');
        scans = InstanceDetailControllerLWC.getScans(myInstance.Id); 
        system.debug('4');
        Test.stopTest();
        System.assertEquals(scans.size(), 1);
    } 
}