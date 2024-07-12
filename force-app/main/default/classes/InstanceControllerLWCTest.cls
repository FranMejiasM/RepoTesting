/**
 * @description       : Test class for Controller InstanceControllerLWC
 * @author            : Fran Mejías
 * @group             : 
 * @last modified on  : 13-06-2023
 * @last modified by  : Fran Mejías
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   13-06-2023   Fran Mejías   Initial Version
**/
@isTest
public with sharing class InstanceControllerLWCTest {
        
    private class MyMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            if (req.getEndpoint().endsWith('/api/v2/user/me')) {            
                res.setBody('{"data": {"attributes": {"active": "true","valid-until": "2080-08-07 14:58:01","api-key-developer": "12345"}}}');                
                res.setStatusCode(200);   
            }        
            return res;
        }
    }

    @isTest
    static void isConectedOK(){
        
        QC_User__c user = new QC_User__c(User__c = UserInfo.getUserId(), QC_Active__c = true, QC_Valid_Until__c = Date.today().addDays(1));
        insert user;

        Test.startTest();
        Map<String,Object> response = new Map<String,Object>();
        response = instanceControllerLWC.isConnected();
        Test.stopTest();
        System.assertEquals(true, response.get('isConnected'));
        System.assertEquals(Date.today().addDays(1), response.get('expDate'));
    } 

    @isTest
    static void isConectedKO(){
        
        Test.startTest();
        Map<String,Object> response = new Map<String,Object>();
        response = instanceControllerLWC.isConnected();
        Test.stopTest();
        System.assertEquals(false, response.get('isConnected'));
    } 

    @isTest
    static void isConectedExpired(){        
        QC_User__c user = new QC_User__c(User__c = UserInfo.getUserId(), QC_Active__c = true, QC_Valid_Until__c = Date.today().addDays(-5));
        insert user;

        Test.startTest();
        Map<String,Object> response = new Map<String,Object>();
        response = instanceControllerLWC.isConnected();
        Test.stopTest();
        System.assertEquals(false, response.get('isConnected'));
    } 
              
    @isTest
    static void getInstances(){
        
        List<instanceControllerLWC.instanceWrapper> wrap = new List<instanceControllerLWC.instanceWrapper>();

        Instance__c instance = new Instance__c(Id__c = '123', Is_Featured_Banch__c = true);
        insert instance;
        insert new Scann__c(ID__c= '1',Date__c = Datetime.valueOf('2019-07-23 08:25:59'), State__c='SUCCESS', Scan_Type__c='feature-branch-scan', Branch_Name__c='develop', Instance__c= instance.Id);

        Test.startTest();
        wrap = instanceControllerLWC.getInstances();
        Test.stopTest();
        System.assertEquals(false, wrap.isEmpty());
        System.assertEquals(instance.Id, wrap[0].instanceId);
    } 

    @isTest
    static void getInstancesNoInstances(){
        String errorMessage;
        List<instanceControllerLWC.instanceWrapper> wrap = new List<instanceControllerLWC.instanceWrapper>();

        Test.startTest();
        try {        
            wrap = instanceControllerLWC.getInstances();
        } catch (Exception e) {
            errorMessage = e.getMessage();
            system.debug('mensaje: ' + errorMessage);
        } 
        System.assertEquals(errorMessage, 'There is no any instance available.');
        Test.stopTest();
    } 
    
    @isTest
    static void addAPIKey() { 

        Test.setMock(HttpCalloutMock.class, new MyMock());
        Test.startTest();
        String apiKey = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiNDJkYjg1MTYyNjMwNjdlZjQ4OTY0ODQ0ZGJmMmFiNDYxMTRhNWQzOTE3ZTY3M2YyMWQ0NzVmNzU1NTQ1NDczMzVhMzBiZTZjZjQ1ZTkzNzEiLCJpYXQiOjE2ODEyOTIyODEuMTU3OTQ5LCJuYmYiOjE2ODEyOTIyODEuMTU3OTUxLCJleHAiOjE3MTI5MTQ2ODEuMTU2MDg3LCJzdWIiOiIxMDQ4Iiwic2NvcGVzIjpbIndyaXRlLW9mZnMiLCJsaXZlLWNoZWNrIiwidXBkYXRlc2V0LXNjYW5zIiwiZnVsbC1zY2FucyIsImFwcGxpY2F0aW9uLXNjYW5zIiwiaW5zdGFuY2VzIiwibGljZW5zZXMiLCJhcGkta2V5cyIsInBlZXItcmV2aWV3IiwiZmVhdHVyZWJyYW5jaC1zY2FucyIsImNoZWNrLW5vdGlmaWNhdGlvbnMiXX0.ffwmQG2FYnslMpCImipkbKc0YNnAfayMJzsTt79wENdUqhUoiGxkHopSXgN1eqFbAePOO27xMzZb1-TmfH2imaWWio07fFTjviC8qNF7tEPXNqc_LhnSPjBNwmSlyqxcdY89rf60DyGs2HOUQfeMwlelqzB1fupWaA4hIrSB4djlMUJWBtvJzhLCrXQqJ2Ej-zg7DqpNRTR7dEw4XZ8thgkG3kEdXN9d6VJrGrslUp4fcRKMbivX-keOFAlYFJFDrM1rcvp34QHrm2-V8qeJ8PAAa-VkTVTnEolnOM60wA61EpzQrlAZQhRZI39j6FbSVqaAFvt6hJnO1ikGjCr7bf5QtRQqlqIrs8wKcyZ5yni_PhwG_bVgVyJU5AgA3Qqd-6UFjY0FLlBkbB8ojtOznBISiEwIPyrNbi3Guh5cN9kKoHKfonLa1YRTCcH76-bAGA1dyT6tEVg2Xm1Sf1KQsLxv0idY-EjjS6aJR79_tyeJWUvPWIQA8ccvNGxr1hehnsoMbTkmxMScxwR_2MylnhnVNOQmxlFJ7FGQXzeOGyZUqve4hFwliWBa1WRi1U_QL7_EaISxyrwKSy-sQfbr1LsxdcZnTFpXOAHf7eqm9SrKoYkYEa_bUWleRA8t2qSkUxU2yQgO3BMQr9ASiZifqcnEsKI-yn4LbPWxmC_tXg8';

        Map<String,Object> response = new Map<String,Object>();

        response = instanceControllerLWC.addApiKey(apiKey);
        
        QC_User__c testQCUser = [SELECT User__c FROM QC_User__c LIMIT 1];

        System.assertEquals(testQCUser.User__c, UserInfo.getUserId());
        System.assertEquals(response.get('isSuccess'), 'OK');
        System.assertEquals(response.get('message'), 'Connection with Quality Clouds established');               
        Test.stopTest();   
    } 

    @isTest
    static void updateInstances(){
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('instancesok');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);        
        Test.startTest();
        Map<String,Object> response = new Map<String,Object>();
        response = instanceControllerLWC.updateInstances();
        Test.stopTest();
        System.assertEquals(response.get('isSuccess'), 'OK');        
        List<Instance__c> lstInstances = [SELECT Id FROM Instance__c];
        System.assertEquals(lstInstances.size(), 4);
    } 
}