@IsTest
public class DashboardControllerTest {

    private class MockOK implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().contains('/scan?filter[url]=')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"meta":{"current-page":1,"per-page":1,"from":1,"to":1,"total":3,"last-page":3,'+
                '"total_resources":3,"resources_per_page":1},"links":{"first":'+
                '"https://services-development.qualityclouds.com/api/v2/scan?filter%5Burl%5D=706&'+
                'filter%5Bstatus%5D=LOADED&filter%5Bscan_type%5D=0&page%5Bnumber%5D=1&page%5Bsize%5D=1",'+
                '"next":"https://services-development.qualityclouds.com/api/v2/scan?filter%5Burl%5D=706&'+
                'filter%5Bstatus%5D=LOADED&filter%5Bscan_type%5D=0&page%5Bnumber%5D=2&page%5Bsize%5D=1",'+
                '"last":"https://services-development.qualityclouds.com/api/v2/scan?filter%5Burl%5D=706&'+
                'filter%5Bstatus%5D=LOADED&filter%5Bscan_type%5D=0&page%5Bnumber%5D=3&page%5Bsize%5D=1"},'+
                '"data":[{"type":"scan","id":"a961f1d8-0ac7-48e6-be95-ace2c56aa37a","attributes":{'+
                '"url":"https://qualityclouds4-dev-ed--c.visualforce.com","target":"6","customer-id":2187,'+
                '"user-id":872,"scan-date":"2021-07-01 09:40:55","internal-code":0,"exit-code":0,'+
                '"status":"SUCCESS","process-time":"796.00","number-of-issues":874,"technical-debt":"350.0",'+
                '"quality-of-cloud":"96.00","best-practices-number":182,"scanned-configuration-elements":1352,'+
                '"code-lines":4165,"changes-issues-ratio":"6.59","code-changes-issues-ratio":"78.38",'+
                '"administrators":null,"users":null,"instance-build-date":null,"last-upgrade-date":null,'+
                '"last-update-set-date":null,"issues-variation":"-72.26","technical-debt-variation":"-79.58",'+
                '"quality-of-cloud-variation":"10.34","code-lines-added":4165,'+
                '"engine-version":"21.2.2.0-SNAPSHOT","customer-name":"test ",'+
                '"is-profiling":false,"service-id":2,"scan-type":0,"scan-details":"[INFO] Recovering'+
                ' information of the instance id = 706<br><br>[INFO] Information of the instance'+
                ' recovered succesfully<br><br>[INFO] Snapshot Generation Started<br><br>[INFO]'+
                ' Snapshot Generation Finished<br><br>[INFO] Number of API Calls: 658<br><br>[INFO]'+
                ' Starting configuration vs customisation calculation<br><br>[INFO] Finished'+
                ' configuration vs customisation calculation<br><br>[INFO] Recovering the information'+
                ' of the best practices<br><br>[INFO] The information of the best practices was'+
                ' recovered: 215 practices<br><br>[INFO] Executing PMD Rules<br><br>[INFO] PMD'+
                ' finished execution<br><br>[INFO] Executing Quality Clouds Rules<br><br>[INFO]'+
                ' Quality Clouds Rules executed<br><br>[INFO] Starting metadata generation'+
                '<br><br>[INFO] Metadata generated succesfully<br><br>[INFO] The Delta Issues'+
                ' were saved succesfully<br><br>[INFO] The snapshots were saved succesfully'+
                '<br><br>[INFO] Delta Elements were saved succesfully<br><br>[INFO] The'+
                ' duplicates were saved succesfully<br><br>[INFO] The license information was'+
                ' saved succesfully<br><br>[INFO] The scan was saved succesfully<br><br>[INFO]'+
                ' Starting Quality Gate calculation<br><br>[INFO] Quality Gate calculation finished'+
                ' successfully","status-detail":"SUCCESS","instance-id":706,"short-id":10474,'+
                '"version":"Summer 21","patch":null,"edition":"Developer Edition",'+
                '"api-version":"52.0","quality-gate-definition-nameid":'+
                '"0fbbd964-fca3-4bf5-badd-968c2f08a454","quality-gate-result":"FAIL",'+
                '"quality-gate-message":"Quality Gate does not allow code with any new issues.'+
                ' Make sure you solve these first.","is-baseline":false},"links":{'+
                '"self":"http://services-development.qualityclouds.com/api/v2/scan/'+
                'a961f1d8-0ac7-48e6-be95-ace2c56aa37a","related":{"href":'+
                '"http://services-development.qualityclouds.com/api/v2/issue/?filter[scan]'+
                '=a961f1d8-0ac7-48e6-be95-ace2c56aa37a",'+
                '"meta":{"total-warnings":0,"total-write-offs":0}}}}]}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().contains('/salesforce-instance/')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"data":{"type":"salesforce-instance","id":"706",'+
                '"attributes":{"description":"6","environment-id":1,'+
                '"environment":"Development","service-name":"Salesforce",'+
                '"url":"https://qualityclouds4-dev-ed--c.visualforce.com",'+
                '"login-url":"https://qualityclouds4-dev-ed--c.visualforce.com",'+
                '"last-scan-test-result":"SUCCESS","last-scan-test-datetime":'+
                '"2021-07-01 09:42:36","last-scan-test-details":"SUCCESS",'+
                '"target":"org","is-feature-branch":false,"git-flavor-id":null,'+
                '"git-repository-url":null,"git-branch":null,"go-live":null,'+
                '"dont-persist-credentials":false,"salesforce-login-url":'+
                '"https://qualityclouds4-dev-ed--c.visualforce.com/services/'+
                'oauth2/authorize?response_type=code&client_id=tSgV7prCWOXU'+
                '3nS2NZw4k5hYekafbQ84hcpWq1Ts4l9YiW18E7XzJPUhiBQzggFnjD4uaQ'+
                'IeIWWbUzjq6rnOGCNZm40aFEVofryR&'+
                'redirect_uri=https://services-development.qualityclouds.com/sf_instance/'+
                'code_callback&state=706&display=popup&prompt=login&scope=api%20refresh_token",'+
                '"org-id":"00D5Y000001dbMpUAI","active":true,"quality-gate-status":"active",'+
                '"num-alerts":0,"autoapproved-writeoffs":false,"has-quality-gates":true,'+
                '"has-quality-gates-with-scan":true},'+
                '"links":{"self":"http://services-development.qualityclouds.com/api/v2/salesforce-instance/706"}}}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().contains('/cust-vs-config-compact/')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"trend":[{"data":[{"scanId":10121,"label":"2021-05-03T15:29:12Z","value":"35.97"}'+
                ',{"scanId":10168,"label":"2021-05-11T15:11:39Z","value":"39.46"},{"scanId":10179,'+
                '"label":"2021-05-13T11:01:05Z","value":"39.86"},{"scanId":10474,'+
                '"label":"2021-07-01T09:40:55Z","value":"38.96"}],"name":"Customization'+
                ' vs Configuration Ratio"}],"variation":-35.21,"inverseVariation":true,'+
                '"value":"38.96","configurationRatio":"61.04","benchmark":"40.31"}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().contains('/issues-over-time-compact/')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"trend":[{"data":[{"scanId":10121,"label":"2021-05-03T15:29:12Z","value":"3093"}'+
                ',{"scanId":10168,"label":"2021-05-11T15:11:39Z","value":"3110"},{"scanId":10179,'+
                '"label":"2021-05-13T11:01:05Z","value":"3151"},{"scanId":10474,'+
                '"label":"2021-07-01T09:40:55Z","value":"874"}],"name":"Issues Over Time Trend"}],'+
                '"variation":-72.26,"inverseVariation":true,"value":874,"average":1762,"issuesWrittenOff":0,'+
                '"previous":3151,"baseline":874,"dataPrivacy":0,"bespokeRules":0,"defaultNamespace":874,'+
                '"numOpenIssues":19,"numClosedIssues":2296,"numIssuesByGroupType":'+
                '[{"label":"Org.config","value":"10"},{"label":"Apex","value":"725"},'+
                '{"label":"others","value":"139"}]}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().contains('/tech-debt-compact/')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"trend":[{"data":[{"scanId":10121,"label":"2021-05-03T15:29:12Z",'+
                '"value":"1683.9"},{"scanId":10168,"label":"2021-05-11T15:11:39Z","value":"1688.7"}'+
                ',{"scanId":10179,"label":"2021-05-13T11:01:05Z","value":"1713.7"},{"scanId":10474,'+
                '"label":"2021-07-01T09:40:55Z","value":"350.1"}],"name":"Technical Debt Trend"}],'+
                '"variation":-79.57,"inverseVariation":true,"value":350.1,"average":848.0,"previous":1713.7,'+
                '"baseline":350.0,"numGlobal":1050.25,"defaultNamespace":350.0,'+
                '"numNewTechDebt":12.9,"numClosedTechDebt":1376.5}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().contains('/issues-by-scan/')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"data":[{"data":[{"scanId":10474,"label":"high","value":"23"}'+
                ',{"scanId":10474,"label":"medium","value":"806"},{"scanId":10474,"label":"low","value":"45"}'+
                ',{"scanId":10474,"label":"warning","value":"22"}],"name":"Issues by Severity"}'+
                ',{"data":[{"scanId":10474,"label":"SCALABILITY","value":"3"},'+
                '{"scanId":10474,"label":"PERFORMANCE","value":"57"},'+
                '{"scanId":10474,"label":"MANAGEABILITY","value":"793"},'+
                '{"scanId":10474,"label":"SECURITY","value":"43"}],"name":"Issues by Area"},'+
                '{"data":[{"scanId":10474,"label":"Missing ApexDoc comment","value":"277"},'+
                '{"scanId":10474,"label":"Final variables should be fully capitalized and non-final'+
                ' variables should not include underscores.","value":"262"},{"scanId":10474,'+
                '"label":"Avoid picklist fields with too many values","value":"19"},{"scanId":10474,'+
                '"label":"Avoid excessive standard cyclomatic complexity.","value":"18"},'+
                '{"scanId":10474,"label":"Avoid using if..else statements without using surrounding braces.",'+
                '"value":"15"},{"scanId":10474,"label":"Access permissions should be checked before a'+
                ' SOQL/SOSL/DML operation.","value":"15"},{"scanId":10474,"label":"Avoid custom fields without'+
                ' Description or Help text","value":"14"},{"scanId":10474,"label":"Class names should always'+
                ' begin with an upper case character.","value":"14"},{"scanId":10474,"label":"Avoid methods with'+
                ' excessive Lines of Code count.","value":"14"},{"scanId":10474,"label":"Avoid objects without'+
                ' indexed fields","value":"14"}],"name":"Issues by Best Practice"},{"data":'+
                '[{"scanId":10474,"label":"N/A","value":"896"},{"scanId":10474,"label":"copado","value":"0"}],'+
                '"name":"Issues by Application"},{"data":[{"scanId":10474,"label":"wwwwq","value":"841"},'+
                '{"scanId":10474,"label":"N/A","value":"49"},{"scanId":10474,"label":"salesforce.com, inc.",'+
                '"value":"6"}],"name":"Issues by Developer"}],'+
                '"meta":{"total_resources":90,"resources_per_page":10,"from":1,"to":10}}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().contains('/ces-by-type/')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"data":[{"data":[{"scanId":10474,"label":"Custom Field","value":"1009"},'+
                '{"scanId":10474,"label":"Object","value":"171"},{"scanId":10474,"label":"Layout","value":"49"},'+
                '{"scanId":10474,"label":"Profile","value":"37"},{"scanId":10474,"label":"Apex Class","value":"33"},'+
                '{"scanId":10474,"label":"Role","value":"18"},{"scanId":10474,"label":"Report","value":"11"},'+
                '{"scanId":10474,"label":"Apex Page","value":"8"},{"scanId":10474,"label":"Apex Trigger","value":"4"},'+
                '{"scanId":10474,"label":"Permission Set","value":"3"},'+
                '{"scanId":10474,"label":"Installed Package","value":"2"},'+
                '{"scanId":10474,"label":"Report Type","value":"2"},'+
                '{"scanId":10474,"label":"Sharing Rules","value":"2"},'+
                '{"scanId":10474,"label":"Application","value":"1"},'+
                '{"scanId":10474,"label":"Dashboard","value":"1"},'+
                '{"scanId":10474,"label":"Workflow","value":"1"},'+
                '{"scanId":10474,"label":"Apex Component","value":"0"},'+
                '{"scanId":10474,"label":"Approval Process","value":"0"},'+
                '{"scanId":10474,"label":"Duplicate","value":"0"},'+
                '{"scanId":10474,"label":"Email Template","value":"0"},'+
                '{"scanId":10474,"label":"Flow","value":"0"},'+
                '{"scanId":10474,"label":"Group","value":"0"},{"scanId":10474,"label":"Lightning","value":"0"},'+
                '{"scanId":10474,"label":"Network","value":"0"},{"scanId":10474,"label":"Org. Config.","value":"0"},'+
                '{"scanId":10474,"label":"Static Resource","value":"0"},'+
                '{"scanId":10474,"label":"Workflow Rule","value":"0"}],'+
                '"name":"Number of configuration elements by type"}]}');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().contains('/data-privacy-compact/')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody('{"trend":[{"data":[{"scanId":10121,"label":"2021-05-03T15:29:12Z","value":"61"}'+
                ',{"scanId":10168,"label":"2021-05-11T15:11:39Z","value":"61"},'+
                '{"scanId":10179,"label":"2021-05-13T11:01:05Z","value":"61"},'+
                '{"scanId":10474,"label":"2021-07-01T09:40:55Z","value":"18"}],'+
                '"name":"Data Privacy"}],"variation":-70.49,"inverseVariation":true,"value":18,"prevScan":61,'+
                '"sensitive":13,"extraSensitive":0,"privateIssues":0}');
                res.setStatusCode(200);
                return res;
            } else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
        }
    }

    @IsTest
    static void givenNoInstanceRecords_WhenGetCheckIfOrgConnected_ThenFalse(){
        DashboardController ctrl = new DashboardController();
        Test.startTest();
        Boolean result = ctrl.getCheckIfOrgConnected();
        Test.stopTest();
        System.assertEquals(false, result);
    }

    @IsTest
    static void givenInstanceRecordWithOrgID_WhenGetCheckIfOrgConnected_ThenTrue(){
        DashboardController ctrl = new DashboardController();
        String currentOrgId = UserInfo.getOrganizationId();
        Instance__c inst = new Instance__c();
        inst.Inst_Org_Id__c = currentOrgId;
        inst.ID__c = '54d54d';
        insert inst;
        Test.startTest();
        Boolean result = ctrl.getCheckIfOrgConnected();
        System.assertEquals(true, result);
        Test.stopTest();
    }

    @IsTest
    static void givenNoRecords_WhenGetData_ThenNewDataWrapper(){
        QC_User__c user = new QC_User__c(QC_Valid_Until__c = date.today().addMonths(1), User__c = UserInfo.getUserId(), QC_Active__c = true);
        upsert user;

        DashboardController ctrl = new DashboardController();
        Test.startTest();            
        DashboardController.DataWrapper actual = ctrl.getData();
            System.assertEquals( null, actual.numbers);
            System.assertEquals( null, actual.configurationElementsData);
            System.assertEquals( null, actual.evolutionOfIssuesData);
            System.assertEquals( null, actual.issuesByBestPracticesData);
            System.assertEquals( null, actual.issuesByImpactAreaData);
        Test.stopTest();
    }

    @IsTest
    static void givenRecordsLoaded_WhenGetData_ThenOK(){
        DashboardController ctrl = new DashboardController();
        QC_User__c user = new QC_User__c(QC_Valid_Until__c = date.today().addMonths(1), User__c = UserInfo.getUserId(), QC_Active__c = true);
        upsert user;
        List<sObject> listDashboardData = Test.loadData(Dashboard_Data__c.sObjectType, 'Test_Dashboard_Data');
        List<sObject> listChart = Test.loadData(Chart__c.sObjectType, 'Test_Chart');
        List<sObject> listDataset = Test.loadData(Dataset__c.sObjectType, 'Test_Dataset');
        System.assertEquals( 2, listDashboardData.size());
        System.assertEquals( 12, listChart.size());
        System.assertEquals( 94, listDataset.size());

        Test.startTest();            
        DashboardController.DataWrapper actual = ctrl.getData();
        System.assertEquals( 96, actual.numbers.QoC__c );
        System.assert(new Set<Decimal>(actual.configurationElementsData.values).contains(171));
        System.assertEquals( '["Custom Field","Object","Layout","Profile","Apex Class","Role","Report","Apex Page","Apex Trigger","Other 7 items"]', actual.configurationElementsData.lables);
        System.assert(new Set<Decimal>(actual.issuesByBestPracticesData.values).contains(277));
        System.assertEquals( '["medium","low","high","warning"]', actual.issuesBySeverityData.lables);
        System.assert(new Set<Decimal>(actual.issuesByImpactAreaData[0].values).contains(793));
        System.assertEquals( '["MANAGEABILITY","PERFORMANCE","SECURITY","SCALABILITY"]', actual.issuesByImpactAreaData[0].lables);
        Test.stopTest();
    }

    @IsTest
    static void givenMockOK_whenUpdateDataFromPortal_ThenNewRecordsCreated(){
        Test.setMock(HttpCalloutMock.class, new MockOK());
        DashboardController ctrl = new DashboardController();
        String currentOrgId = UserInfo.getOrganizationId();
        Instance__c inst = new Instance__c();
        inst.Inst_Org_Id__c = currentOrgId;
        inst.ID__c = '54d54d';
        insert inst;
        Test.startTest();
        PageReference result = ctrl.updateDataFromPortal();
        Test.stopTest();
        Integer actual = [SELECT Count() FROM  Dataset__c];
        System.assertEquals(45, actual, 'Number of created Dataset__c records is not equal to 45');
    }

}