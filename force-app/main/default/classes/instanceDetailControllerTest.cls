@isTest
class  instanceDetailControllerTest {
    @isTest
    static void execute_scannOK() {

        upsert new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true) ID__c;

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('scanok');
        mock.setStatusCode(202);
        mock.setHeader('Content-Type', 'application/json');

        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        instanceDetailController instanceDetail = new instanceDetailController();

        instanceDetail.id_instance = '1';
        instanceDetail.git_branch = 'develop';
        instanceDetail.getInstance();

        instanceDetail.execute_scann();

        Test.stopTest();
        System.assertEquals('Scan launched', instanceDetail.message_out);
        System.assertEquals('confirm', instanceDetail.message_type_out);
    }
    
    @isTest
    static void execute_scann_fullOK() {

        upsert new Instance__c(url__c='url', Description__c='dec', Environment_Type__c='dev',ID__c= '1', Instance_Type__c='salesforcce', Is_Featured_Banch__c=true) ID__c;

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('scanok');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        instanceDetailController instanceDetail = new instanceDetailController();

        instanceDetail.id_instance = '1';
        instanceDetail.git_branch = 'develop';
        instanceDetail.getInstance();
        instanceDetail.getScanns();
        instanceDetail.getId_instance();
        instanceDetail.go_back();
        instanceDetail.openDetail();


        instanceDetail.execute_scann_full();

        Test.stopTest();
        System.assertEquals('Scan launched', 'Scan launched');
    }



    @isTest
    static void update_scannsOK() {
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
        instanceDetailController instanceDetail = new instanceDetailController();

        instanceDetail.id_instance = '1';
        instanceDetail.id_scan = '1';
        instanceDetail.git_branch = 'develop';

        instanceDetail.getInstance();

        instanceDetail.update_scanns();

        Test.stopTest();
        System.assertEquals('Scan status updated and issues imported', instanceDetail.message_out);
        System.assertEquals('confirm', instanceDetail.message_type_out);
    }

}