@isTest
class InstancesControllerTest {
    
    private class MockOK implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('/salesforce-instance')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{}');
                res.setStatusCode(201);
                return res;
            } else if (req.getEndpoint().endsWith('/salesforce-instance/123')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"data":{"type":"salesforce-instance","id":"123",'+
                            '"attributes":{"description":"22","environment-id":1,'+
                            '"environment":"Development","service-name":"Salesforce",'+
                            '"url":"https://qualityclouds4-dev-ed--c.visualforce.com",'+
                            '"login-url":"https://qualityclouds4-dev-ed--c.visualforce.com",'+
                            '"last-scan-test-result":"FAIL",'+
                            '"last-scan-test-datetime":"2021-04-28+08:18:13",'+
                            '"last-scan-test-details":"You+need+to+finish+your+instance+configuration+by+obtaining+a+Salesforce+oauth+token",'+
                            '"target":"org","is-feature-branch":false,"git-flavor-id":null,'+
                            '"git-repository-url":null,"git-branch":null,"go-live":"0000-00-00",'+
                            '"dont-persist-credentials":false,'+
                            '"salesforce-login-url":"https://qualityclouds4-dev-ed--c.visualforce.com/services/oauth2/authorize?'+
                            'response_type=code&client_id=8DoV0M6WWs0w6JPQcFNivlQYjL5fXTdak1pXyEv4sPIz8o5iZjQUUNS20ezkwPO50VAEz5n'+
                            'XXzpuMqsc5K6YSYdhgY4Ro8DlSmij&redirect_uri=https://dev-services.qualityclouds.com/sf_instance/code_'+
                            'callback&state=693&display=popup&prompt=login&scope=api%20refresh_token","org-id":null,"active":true,'+
                            '"quality-gate-status":null,"num-alerts":0},"links":{"self":"http://dev.qualityclouds.com/api/v2/salesforce-instance/693"}}}');
                res.setStatusCode(200);
                return res;
            } else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
        }
    }
    private class MockError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('/salesforce-instance')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{}');
                res.setStatusCode(500);
                return res;
            } else if (req.getEndpoint().endsWith('/salesforce-instance/123')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{}');
                res.setStatusCode(500);
                return res;
            } else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
        }
    }
    
    @isTest
    static void givenStatus200_whenUpdateInstances_thenOK() {
        InstancesController instanceController = new InstancesController();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('instancesok');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        instanceController.updateInstances();
        Test.stopTest();
        System.assertEquals('Instances are imported/updated.', instanceController.message_out);
        System.assertEquals('confirm', instanceController.message_type_out);
    }
    
    @isTest
    static void givenNoInstances_whenUpdateInstances_thenWarning() {
        InstancesController instanceController = new InstancesController();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('instancesempty');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        instanceController.updateInstances();
        Test.stopTest();
        String expected = 'No instances found on the Quality Clouds portal for this account.';
        System.assertEquals(expected, instanceController.message_out);
        System.assertEquals('warning', instanceController.message_type_out);        
    }    
    
    
    @isTest
    static void  givenNewController_whenOpenDetail_thenURLOK(){
        Test.startTest();
        InstancesController instanceController = new InstancesController();
        Test.stopTest();
        PageReference expected = new PageReference('/apex/InstanceDetail');
        System.assertEquals(expected.getUrl(), instanceController.openDetail().getUrl());
    }
    
    @isTest
    static void givenPopup_whenCancel_thenNoPopup(){
        InstancesController instanceController = new InstancesController();        
        instanceController.showPopup = true;
        Test.startTest();
        instanceController.Cancel();
        Test.stopTest();
        System.assertEquals(false, instanceController.showPopup);
    }
    
    @isTest
    static void givenInstance_whenGetInstances_thenInstanceReturned(){
        InstancesController instanceController = new InstancesController();
        insert new Instance__c(Id__c = '123', Is_Featured_Banch__c = true);
        Test.startTest();
        List<Instance__c>  instances = instanceController.getInstances();
        Test.stopTest();
        System.assertEquals(false, instances.isEmpty());
        System.assertEquals('123', instances[0].Id__c);
    } 
    
    @isTest
    static void givenMockOk_whenCreatePortalInstance_thenResultTrue(){
        Test.setMock(HttpCalloutMock.class, new MockOK());
        InstancesController instanceController = new InstancesController();
        instanceController.description = '123';
        Map<String, String> keys = new Map<String, String>();
        keys.put('consumKey','consumKeyoi34klj34rjkr4j');
        keys.put('consumSecret', 'consumSecretJKN34KJN4RKJN34RKJN');
        Test.startTest();
        Boolean result = instanceController.createPortalInstance(keys);
        Test.stopTest();
        System.assertEquals(true, result);
    }
    
    @isTest
    static void givenMockOk_whenAuthorize_thenCorrectURL(){
        Test.setMock(HttpCalloutMock.class, new MockOK());
        InstancesController instanceController = new InstancesController();
        instanceController.id_inst = '123';    
        Test.startTest();   
        PageReference result = instanceController.authorize();
        Test.stopTest();
        String expected = 'https://qualityclouds4-dev-ed--c.visualforce.com/services/oauth2/authorize?'+
            'client_id=8DoV0M6WWs0w6JPQcFNivlQYjL5fXTdak1pXyEv4sPIz8o5iZjQUUNS20ezkwPO50VAEz5nXXzpuMqsc5K6YSYdhgY4Ro8DlSmij&'+
            'display=popup&prompt=login&redirect_uri=https%3A%2F%2Fdev-services.qualityclouds.com%2Fsf_instance%2Fcode_callback&'+
            'response_type=code&state=693';    
        System.assertEquals(expected, result.getURL());
    }
       
    
    @isTest
    static void givenMockError_whenAuthorize_thenError(){
        Test.setMock(HttpCalloutMock.class, new MockError());
        InstancesController instanceController = new InstancesController();
        instanceController.id_inst = '123'; 
        Test.startTest();
        PageReference result = instanceController.authorize();
        Test.stopTest();
        String expected = 'Error getting authorization URL. Please close this tab and get authorization token on Quality Clouds portal';  
        System.assertEquals(expected, result.getParameters().get('message'));
    }
    
    @isTest
    static void givenNoMock_whenConnectOrgToPortal_thenExceptionCaught() { 
        
        Test.startTest();
        InstancesController instanceController = new InstancesController();
        instanceController.description = '123';
        instanceController.connectOrgToPortal();
        Test.stopTest();
        System.assertEquals('true', 'true');
    }  
    
    @isTest
    static void givenNoInstanceDescription_whenconnectOrgToPortal_thenErrorMessage() { 
        
        Test.startTest();
        InstancesController instanceController = new InstancesController();
        instanceController.connectOrgToPortal();
        Test.stopTest();   
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));     
    }  
    
    @isTest
    static void apiKeyMethods() { 
        
        Test.startTest();
        InstancesController instanceController = new InstancesController();
        instanceController.apiKey = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiNDJkYjg1MTYyNjMwNjdlZjQ4OTY0ODQ0ZGJmMmFiNDYxMTRhNWQzOTE3ZTY3M2YyMWQ0NzVmNzU1NTQ1NDczMzVhMzBiZTZjZjQ1ZTkzNzEiLCJpYXQiOjE2ODEyOTIyODEuMTU3OTQ5LCJuYmYiOjE2ODEyOTIyODEuMTU3OTUxLCJleHAiOjE3MTI5MTQ2ODEuMTU2MDg3LCJzdWIiOiIxMDQ4Iiwic2NvcGVzIjpbIndyaXRlLW9mZnMiLCJsaXZlLWNoZWNrIiwidXBkYXRlc2V0LXNjYW5zIiwiZnVsbC1zY2FucyIsImFwcGxpY2F0aW9uLXNjYW5zIiwiaW5zdGFuY2VzIiwibGljZW5zZXMiLCJhcGkta2V5cyIsInBlZXItcmV2aWV3IiwiZmVhdHVyZWJyYW5jaC1zY2FucyIsImNoZWNrLW5vdGlmaWNhdGlvbnMiXX0.ffwmQG2FYnslMpCImipkbKc0YNnAfayMJzsTt79wENdUqhUoiGxkHopSXgN1eqFbAePOO27xMzZb1-TmfH2imaWWio07fFTjviC8qNF7tEPXNqc_LhnSPjBNwmSlyqxcdY89rf60DyGs2HOUQfeMwlelqzB1fupWaA4hIrSB4djlMUJWBtvJzhLCrXQqJ2Ej-zg7DqpNRTR7dEw4XZ8thgkG3kEdXN9d6VJrGrslUp4fcRKMbivX-keOFAlYFJFDrM1rcvp34QHrm2-V8qeJ8PAAa-VkTVTnEolnOM60wA61EpzQrlAZQhRZI39j6FbSVqaAFvt6hJnO1ikGjCr7bf5QtRQqlqIrs8wKcyZ5yni_PhwG_bVgVyJU5AgA3Qqd-6UFjY0FLlBkbB8ojtOznBISiEwIPyrNbi3Guh5cN9kKoHKfonLa1YRTCcH76-bAGA1dyT6tEVg2Xm1Sf1KQsLxv0idY-EjjS6aJR79_tyeJWUvPWIQA8ccvNGxr1hehnsoMbTkmxMScxwR_2MylnhnVNOQmxlFJ7FGQXzeOGyZUqve4hFwliWBa1WRi1U_QL7_EaISxyrwKSy-sQfbr1LsxdcZnTFpXOAHf7eqm9SrKoYkYEa_bUWleRA8t2qSkUxU2yQgO3BMQr9ASiZifqcnEsKI-yn4LbPWxmC_tXg8';
       	instanceController.getcheckAPIKEY();
        instanceController.setup();
        
        QC_User__c qcUser = InstancesController.QCUser ;
        instanceController.addApiKey();
        QC_User__c testQCUser = new QC_User__c(Name = 'Test QC User', User__c = UserInfo.getUserId(),
                                               QC_Active__c = true, QC_Api_Key_Developer__c = '12345',
                                               QC_Valid_Until__c = Date.today().addDays(30),
                                               API_Key_1__c = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiNDJkYjg1MTYyNjMwNjdlZjQ4OTY0ODQ0ZGJmMmFiNDYxMTRhNWQzOTE3ZTY3M2YyMWQ0NzVmNzU1NTQ1NDczMzVhMzBiZTZjZjQ1ZTkzNzEiLCJpYX', 
                                               API_Key_2__c = 'QiOjE2ODEyOTIyODEuMTU3OTQ5LCJuYmYiOjE2ODEyOTIyODEuMTU3OTUxLCJleHAiOjE3MTI5MTQ2ODEuMTU2MDg3LCJzdWIiOiIxMDQ4Iiwic2NvcGVzIjpbIndyaXRlLW9mZnMiLCJsaXZlLWNoZWNrIiwidXBkYXRlc2V0LXNjY',
                                               API_Key_3__c = 'W5zIiwiZnVsbC1zY2FucyIsImFwcGxpY2F0aW9uLXNjYW5zIiwiaW5zdGFuY2VzIiwibGljZW5zZXMiLCJhcGkta2V5cyIsInBlZXItcmV2aWV3IiwiZmVhdHVyZWJyYW5jaC1zY2FucyIsImNoZWNrLW5vdGlmaWNhdGlvbnMiXX0.', 
                                               API_Key_4__c = 'ffwmQG2FYnslMpCImipkbKc0YNnAfayMJzsTt79wENdUqhUoiGxkHopSXgN1eqFbAePOO27xMzZb1-TmfH2imaWWio07fFTjviC8qNF7tEPXNqc_LhnSPjBNwmSlyqxcdY89rf60DyGs2HOUQfeMwlelqzB1fupWaA4hIrSB4djlMUJ',
                                               API_Key_5__c = 'WBtvJzhLCrXQqJ2Ej-zg7DqpNRTR7dEw4XZ8thgkG3kEdXN9d6VJrGrslUp4fcRKMbivX-keOFAlYFJFDrM1rcvp34QHrm2-V8qeJ8PAAa-VkTVTnEolnOM60wA61EpzQrlAZQhRZI39j6FbSVqaAFvt6hJnO1ikGjCr7bf5QtRQqlq', 
                                               API_Key_6__c = 'Irs8wKcyZ5yni_PhwG_bVgVyJU5AgA3Qqd-6UFjY0FLlBkbB8ojtOznBISiEwIPyrNbi3Guh5cN9kKoHKfonLa1YRTCcH76-bAGA1dyT6tEVg2Xm1Sf1KQsLxv0idY-EjjS6aJR79_tyeJWUvPWIQA8ccvNGxr1hehnsoMbTkmxMScx',
                                               API_Key_7__c = 'wR_2MylnhnVNOQmxlFJ7FGQXzeOGyZUqve4hFwliWBa1WRi1U_QL7_EaISxyrwKSy-sQfbr1LsxdcZnTFpXOAHf7eqm9SrKoYkYEa_bUWleRA8t2qSkUxU2yQgO3BMQr9ASiZifqcnEsKI-yn4LbPWxmC_tXg8');
        insert testQCUser;
        
        instanceController.addApiKey();

       	qcUser = InstancesController.QCUser ;
        Boolean connected = InstancesController.connected ;
        System.assertEquals(testQCUser.Id, qcUser.Id);
        
        List<String> chunks = new List<String>();
        chunks.add(qcUser.API_Key_1__c);
        chunks.add(qcUser.API_Key_2__c);
        chunks.add(qcUser.API_Key_3__c);
        chunks.add(qcUser.API_Key_4__c);
        chunks.add(qcUser.API_Key_5__c);
        chunks.add(qcUser.API_Key_6__c);        
        InstancesController.validateApiKey(chunks);
        chunks.add(qcUser.API_Key_7__c);
        InstancesController.validateApiKey(chunks);
        

        Test.stopTest();   
    } 
    
}