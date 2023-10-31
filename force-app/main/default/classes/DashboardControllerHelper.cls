public with sharing class DashboardControllerHelper {
    
    public class DashboardControllerHelperException extends Exception {}

    public final static String GROUP_LABEL_ISSUES = 'Issues';
    public final static String GROUP_LABEL_TECH_DEBT = 'Technical Debt';
    final static String CHART_LABEL_SENSITIVE = 'Sensitive';
    final static String CHART_LABEL_EXTRA_SENSITIVE = 'Extra Sensitive';
    final static String CHART_LABEL_PRIVATE = 'Private';
    public final static String CHART_NAME_IBP = 'Issues by Best Practices';
    public final static String CHART_NAME_EOI = 'Evolution Of Issues';
    public final static String CHART_NAME_IIA = 'Issues by Impact Area';
    public final static String CHART_NAME_IDP = 'Issues Data Privacy';
    public final static String CHART_NAME_CE = 'Configuration Elements';
    public final static String CHART_NAME_IBS = 'Issues by Severity';
    final static String MSG_NO_NEW_DATA = ' The data is up to date. No new scans available.';
    final static String MSG_OK = 'OK';
    final static String MSG_EXCEPTION_CREATE_DASHBOARD_DATA = 'Current user does not have rights to create Dashboard_Data__c object.';
    final static String MSG_EXCEPTION_CREATE_DATASET = 'Current user does not have rights to create Dataset__c object.';
    final static String MSG_EXCEPTION_CREATE_CHART = 'Current user does not have rights to create Chart__c object.';
    final static String MSG_EXCEPTION_NO_SCANS = 'No successful scans found for this org. Please trigger scan for this org to display the dashboard data.';
    
    Dashboard_Data__c dashboardNumbers;
    String instanceID;
    QualityCloudsSettings__mdt settings;
    Integer scanShortID;
    Http http;
    List<Dataset__c> datasetsToInsert;    
    List <IssuesCompactJSON2Apex.Data> issuesCompactData;    
    List <IssuesCompactJSON2Apex.Data> techDebtCompactData;
    List <DataDataJSON2Apex.Data_Z> issuesBySeverityAreaBPData;
    List <DataDataJSON2Apex.Data> confElementsData;
    IssuesCompactJSON2Apex dataPrivacy;
    
    private HttpRequest createRequest(){
        HttpRequest req = new HttpRequest();        
        req.setHeader('Accept', '*/*');
        req.setHeader('Authorization', 'Bearer '+ ControllerHelperQC.getAPIKEY());                
        req.setMethod('GET');
        req.setHeader('client-name', 'GenericHttpClient');
        return req;
    }
    
    private HTTPResponse callLastScanInfo(HttpRequest req){
        req.setEndpoint(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/scan?filter[url]=' +  instanceID +  '&page[size]=1&page[number]=1&filter[status]=LOADED&filter[scan_type]=0');
        return http.send(req);
    }
    
    private HTTPResponse callInstanceInfo(HttpRequest req){
        req.setEndpoint(settings.API_Endpoint__c + '/api/'  + settings.API_Version__c + '/salesforce-instance/' +  instanceID);
        return http.send(req);
    }
    
    private HTTPResponse callCustVsConfigCompact(HttpRequest req){
        req.setEndpoint(settings.API_Endpoint_Widgets__c + settings.API_Version_Widgets__c + '/cust-vs-config-compact/' + scanShortID);
        return http.send(req);
    }
    
    private HTTPResponse callIssuesOverTimeCompact (HttpRequest req){
        req.setEndpoint(settings.API_Endpoint_Widgets__c + settings.API_Version_Widgets__c + '/issues-over-time-compact/' + scanShortID);
        return http.send(req);
    }
    
    private HTTPResponse callTechDebtCompact (HttpRequest req){
        req.setEndpoint(settings.API_Endpoint_Widgets__c + settings.API_Version_Widgets__c + '/tech-debt-compact/' + scanShortID);
        return http.send(req);
    }
    
    private HTTPResponse callIssuesByScan (HttpRequest req){
        req.setEndpoint(settings.API_Endpoint_Widgets__c + settings.API_Version_Widgets__c + '/issues-by-scan/' + scanShortID);
        return http.send(req);
    }
    
    private HTTPResponse callCesByType (HttpRequest req){
        req.setEndpoint(settings.API_Endpoint_Widgets__c + settings.API_Version_Widgets__c + '/ces-by-type/' + scanShortID + '?providerId=2');
        return http.send(req);
    }
    
    private HTTPResponse callDataPrivacyCompact (HttpRequest req){
        req.setEndpoint(settings.API_Endpoint_Widgets__c + settings.API_Version_Widgets__c + '/data-privacy-compact/' + scanShortID);
        return http.send(req);
    }
    
    private void addLastScanInfoToDashboardNumbers (HTTPResponse res){
        dashboardNumbers = new Dashboard_Data__c();
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        List< Object> dataList = (List<Object>) results.get('data');
        if (dataList.isEmpty()) {
            System.debug(LoggingLevel.Error, res.getBody());
            throw new DashboardControllerHelperException(MSG_EXCEPTION_NO_SCANS); 
        }    
        map<String,Object> data =  (map<String,Object>) dataList[0];
        map<String,Object> attributes = (map<String,Object>) data.get('attributes');
        
        dashboardNumbers.Total_Issues__c = (Integer) attributes.get('number-of-issues');
        if((String) attributes.get('issues-variation') != null){
            dashboardNumbers.Total_Issues_Variation__c = Decimal.valueOf( (String) attributes.get('issues-variation'));
        }else{
            dashboardNumbers.Total_Issues_Variation__c = 0;
        }
        if((String) attributes.get('technical-debt-variation')!= null){
            dashboardNumbers.Technical_Debt_Variation__c = Decimal.valueOf( (String) attributes.get('technical-debt-variation')); 
        }else{
            dashboardNumbers.Technical_Debt_Variation__c = 0; 
        }
        if((String)attributes.get('quality-of-cloud-variation')!= null){
            dashboardNumbers.QoC_Variation__c = Decimal.valueOf( (String)attributes.get('quality-of-cloud-variation')); 
        }else{
            dashboardNumbers.QoC_Variation__c = 0; 
        }
        
        dashboardNumbers.Technical_Debt__c = Decimal.valueOf( (String) attributes.get('technical-debt')); 
        dashboardNumbers.Code_Changes_Issues_Ratio__c =  Decimal.valueOf( (String) attributes.get('code-changes-issues-ratio'));
        dashboardNumbers.QoC__c = Decimal.valueOf( (String)attributes.get('quality-of-cloud'));
        dashboardNumbers.Scan_Date__c = Datetime.valueOf( (String)attributes.get('scan-date'));
        dashboardNumbers.Scan_ID_External__c = (String) data.get('id');
        dashboardNumbers.Org_URL__c = (String)attributes.get('url');
        dashboardNumbers.Org_Edition__c = (String)attributes.get('edition');
        dashboardNumbers.Instance_Description__c = (String)attributes.get('target');
        
        scanShortID = (Integer) attributes.get('short-id');
    }
    
    private void addOrgIdEnvironmentToDashboardNumbers (HTTPResponse res){
        Map<String, Object> instResults = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        Map<String, Object> instData = (Map<String, Object>)instResults.get('data');
        Map<String, Object> attrib = (Map<String, Object>)instData.get('attributes');
        dashboardNumbers.Org_Id__c = (String) attrib.get('org-id');
        dashboardNumbers.Environment__c = (String) attrib.get('environment'); 
    }
    
    private void addCustomizationRatioToDashboardNumbers (HTTPResponse res){
        IssuesCompactJSON2Apex customVsConfig = IssuesCompactJSON2Apex.parse(res.getBody());    
        dashboardNumbers.Customization_Ratio__c = Decimal.valueOf( customVsConfig.value );
    }   
    
    private void addEvolutionOfIssuesToDatasets (List <IssuesCompactJSON2Apex.Data> issuesCompactData, List <IssuesCompactJSON2Apex.Data> techDebtCompactData, Chart__c eoiChart){
        for (IssuesCompactJSON2Apex.Data issueCD : issuesCompactData){
            Dataset__c tempDataset = new Dataset__c ();
            tempDataset.Chart__c = eoiChart.id;
            tempDataset.Group_Label__c = GROUP_LABEL_ISSUES;
            tempDataset.Label__c = issueCD.label;
            tempDataset.Value__c = Decimal.ValueOf(issueCD.value);
            datasetsToInsert.add(tempDataset);
        }
        
        for (IssuesCompactJSON2Apex.Data tDebt : techDebtCompactData){           
            
            Dataset__c tempDataset = new Dataset__c ();
            tempDataset.Chart__c = eoiChart.id;
            tempDataset.Group_Label__c = GROUP_LABEL_TECH_DEBT;
            tempDataset.Label__c = tDebt.label;
            tempDataset.Value__c = Decimal.ValueOf(tDebt.value);
            datasetsToInsert.add(tempDataset);
        }  
    } 
    
    private void addIssuesBySeverityAreaBPToDatasets (List <DataDataJSON2Apex.Data_Z> issuesBySeverityAreaBPData, Chart__c ibsChart, Chart__c iiaChart, Chart__c ibpChart){
        for (DataDataJSON2Apex.Data_Z issueSBP : issuesBySeverityAreaBPData){        
            for (DataDataJSON2Apex.Data issueSBPData : issueSBP.data){
                if (issueSBP.name == 'Issues by Severity'){
                    Dataset__c tempDataset = createDataset(issueSBPData);
                    tempDataset.Chart__c = ibsChart.id;
                    datasetsToInsert.add(tempDataset);
                }else if (issueSBP.name == 'Issues by Area'){
                    Dataset__c tempDataset = createDataset(issueSBPData);
                    tempDataset.Chart__c = iiaChart.id;
                    datasetsToInsert.add(tempDataset);
                }else if (issueSBP.name == 'Issues by Best Practice' && issueSBPData.value != 0){                    
                    Dataset__c tempDataset = createDataset(issueSBPData);
                    tempDataset.Chart__c = ibpChart.id;
                    datasetsToInsert.add(tempDataset);
                }
            } 
        }
    } 
    
    private void addConfigurationElementsToDatasets (List<DataDataJSON2Apex.Data> confElementsData, Chart__c ceChart){
        for (DataDataJSON2Apex.Data confElement : confElementsData){
            if (confElement.value != 0) {
                Dataset__c tempDataset = createDataset(confElement);
                tempDataset.Chart__c = ceChart.id;
                datasetsToInsert.add(tempDataset);
            }
        } 
    } 
    
    private void addIssuesDataPrivacyToDatasets (Chart__c idpChart, IssuesCompactJSON2Apex dataPrivacy){
        Dataset__c tempDataset = new Dataset__c ();
        tempDataset.Chart__c = idpChart.id;
        tempDataset.Label__c = CHART_LABEL_SENSITIVE;
        tempDataset.Value__c = dataPrivacy.sensitive;
        datasetsToInsert.add(tempDataset);
        tempDataset = new Dataset__c ();
        tempDataset.Chart__c = idpChart.id;
        tempDataset.Label__c = CHART_LABEL_EXTRA_SENSITIVE;
        tempDataset.Value__c = dataPrivacy.extraSensitive;
        datasetsToInsert.add(tempDataset);
        tempDataset = new Dataset__c ();
        tempDataset.Chart__c = idpChart.id;
        tempDataset.Label__c = CHART_LABEL_PRIVATE;
        tempDataset.Value__c = dataPrivacy.privateIssues;
        datasetsToInsert.add(tempDataset);
    }
    
    private void getDataFromEndpoints (HttpRequest req){
        HTTPResponse res = callInstanceInfo(req);
        if (res.getStatusCode() == 200){
            addOrgIdEnvironmentToDashboardNumbers(res);
        } else {
            throw new DashboardControllerHelperException(res.getBody());
        }
        
        res = callCustVsConfigCompact(req);
        if (res.getStatusCode() == 200){
            addCustomizationRatioToDashboardNumbers(res);
        } else {
            throw new DashboardControllerHelperException(res.getBody());  
        }
        
        res = callIssuesOverTimeCompact(req);            
        if (res.getStatusCode() == 200){
            issuesCompactData = IssuesCompactJSON2Apex.parse(res.getBody())?.trend[0]?.data;
        }  else {
            throw new DashboardControllerHelperException(res.getBody()); 
        }
        
        res = callTechDebtCompact(req);
        if (res.getStatusCode() == 200){
            techDebtCompactData = IssuesCompactJSON2Apex.parse(res.getBody())?.trend[0]?.data;
        } else {
            throw new DashboardControllerHelperException(res.getBody());  
        }
        
        res = callIssuesByScan(req);
        if (res.getStatusCode() == 200){  
            issuesBySeverityAreaBPData = DataDataJSON2Apex.parse(res.getBody())?.data;            
        } else {
            throw new DashboardControllerHelperException(res.getBody());  
        }
        
        res = callCesByType(req);
        if (res.getStatusCode() == 200){
            confElementsData = DataDataJSON2Apex.parse(res.getBody())?.data[0]?.data;
        } else {
            throw new DashboardControllerHelperException(res.getBody());  
        }            
        
        res = callDataPrivacyCompact(req);
        if (res.getStatusCode() == 200){
            dataPrivacy= IssuesCompactJSON2Apex.parse(res.getBody());        
        } else {
            throw new DashboardControllerHelperException(res.getBody());  
        } 
    }
    
    public String updateDataFromPortal (String instID, Datetime lastScanDate){
        instanceID = instID;
        settings = ControllerHelperQC.getSettings();      
        HttpRequest req = createRequest();
        http = new Http();
        HTTPResponse res = callLastScanInfo(req);
        if (res.getStatusCode() == 200){
            addLastScanInfoToDashboardNumbers (res);

            if (lastScanDate != null && dashboardNumbers.Scan_Date__c != null && lastScanDate >= dashboardNumbers.Scan_Date__c) {
                return MSG_NO_NEW_DATA;
            }
            getDataFromEndpoints(req);
            Savepoint sp = Database.setSavepoint();
            try {
                if (Schema.sObjectType.Dashboard_Data__c.fields.Total_Issues__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Total_Issues_Variation__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Technical_Debt__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Technical_Debt_Variation__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Code_Changes_Issues_Ratio__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.QoC__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.QoC_Variation__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Scan_Date__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Scan_ID_External__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Org_URL__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Org_Edition__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Instance_Description__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Org_Id__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Environment__c.isCreateable()
                    && Schema.sObjectType.Dashboard_Data__c.fields.Customization_Ratio__c.isCreateable()   
                ) {
                    insert dashboardNumbers; 
                } else {
                    throw new DashboardControllerHelperException(MSG_EXCEPTION_CREATE_DASHBOARD_DATA); 
                }
                
                Chart__c ibpChart = new Chart__c();
                ibpChart.Dashboard_Data__c = dashboardNumbers.Id;
                ibpChart.name = CHART_NAME_IBP;
                
                Chart__c eoiChart = new Chart__c();
                eoiChart.Dashboard_Data__c = dashboardNumbers.Id;
                eoiChart.name = CHART_NAME_EOI;
                
                Chart__c iiaChart = new Chart__c();
                iiaChart.Dashboard_Data__c = dashboardNumbers.Id;
                iiaChart.name = CHART_NAME_IIA;
                
                Chart__c idpChart = new Chart__c();
                idpChart.Dashboard_Data__c = dashboardNumbers.Id;
                idpChart.name = CHART_NAME_IDP;
                
                Chart__c ceChart = new Chart__c();
                ceChart.Dashboard_Data__c = dashboardNumbers.Id;
                ceChart.name = CHART_NAME_CE;
                
                Chart__c ibsChart = new Chart__c();
                ibsChart.Dashboard_Data__c = dashboardNumbers.Id;
                ibsChart.name = CHART_NAME_IBS;
                
                List<Chart__c> chartsToInsert = new List<Chart__c> {ibpChart, eoiChart, iiaChart, idpChart, ceChart, ibsChart};
                 
                if (Schema.sObjectType.Chart__c.isCreateable()) {                    
                    insert chartsToInsert;
                } else {
                    throw new DashboardControllerHelperException(MSG_EXCEPTION_CREATE_CHART); 
                }
                
                datasetsToInsert = new List<Dataset__c>();   
                addEvolutionOfIssuesToDatasets (issuesCompactData,  techDebtCompactData, eoiChart);
                addIssuesBySeverityAreaBPToDatasets (issuesBySeverityAreaBPData, ibsChart, iiaChart, ibpChart);
                addConfigurationElementsToDatasets ( confElementsData, ceChart);
                addIssuesDataPrivacyToDatasets ( idpChart,  dataPrivacy);                
                
                if (Schema.sObjectType.Dataset__c.fields.Chart__c.isCreateable()
                    && Schema.sObjectType.Dataset__c.fields.Label__c.isCreateable()
                    && Schema.sObjectType.Dataset__c.fields.Value__c.isCreateable()
                    && Schema.sObjectType.Dataset__c.fields.Group_Label__c.isCreateable()
                ) {
                    insert datasetsToInsert; 
                } else {
                    throw new DashboardControllerHelperException(MSG_EXCEPTION_CREATE_DATASET); 
                }
                return MSG_OK;
            } catch (Exception e) {
                System.debug(LoggingLevel.Error, e.getStackTraceString()); 
                Database.rollback(sp);
                throw new DashboardControllerHelperException(e); 
            }
                       
        } else {
            throw new DashboardControllerHelperException(res.getBody()); 
        }
    }
    
    private Dataset__c createDataset (DataDataJSON2Apex.Data dataElement){
        Dataset__c tempDataset = new Dataset__c ();
        tempDataset.Label__c = dataElement?.label;
        tempDataset.Value__c = Decimal.ValueOf(dataElement?.value);
        return tempDataset;
    }  
}