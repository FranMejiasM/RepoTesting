public with sharing class DashboardController {
    
    private final static String MSG_UPDATED_OK = ' Data updated successfully.';
    private final static String MSG_INVAL_TOKEN = 'No valid token detected. On "Quality Clouds" tab, click "Go To Settings" button and click "Get Token" or "Refresh Token" to get valid token.';
    private final static String MSG_ORG_NOT_CONNECTED = 'Current org is not connected to Quality Clouds service. To be able to scan current org for issues please go to "Quality Clouds" tab. On "Instances" page, click "Connect org to QC" button.';
    private final static String MSG_MORE_THAN_ONE_INST = 'More than 1 instance with current org ID found. Please remove unnecessary instances and try again.';
    public String msgInvalidToken { get; private set; }
    public String msgOrgIsNotConnected { get; private set; }
    private final static Integer ITEMS_TO_SHOW = 10;
    private DataWrapper data; 
    private DatasetcWrapper[] dwList;
    public String message_type_out{get;set;}
    public String message_out{get;set;}
    public String message{get;set;}
    public String message_type{get;set;}

    public DashboardController() {
        msgInvalidToken = MSG_INVAL_TOKEN;
        msgOrgIsNotConnected = MSG_ORG_NOT_CONNECTED;
        message = ApexPages.currentPage().getParameters().get('message');
        message_type = ApexPages.currentPage().getParameters().get('message_type');
    }

    private class DatasetcWrapper implements Comparable {
        private Dataset__c d;
        public DatasetcWrapper(Dataset__c d) {
            this.d = d;
        }
        public Dataset__c getDatasetc (){
            return this.d;
        }
        public Integer compareTo(Object compareTo) {
            DatasetcWrapper ctD = (DatasetcWrapper) compareTo;
            if (ctD.d.Label__c < this.d.Label__c) {
                return +1;
            }
            if (ctD.d.Label__c > this.d.Label__c) {
                return -1;
            }
            return 0; 
        }   
    }    
    
    public class DataWrapper{
        public Dashboard_Data__c numbers {get;set;}
        public List<DataSet> evolutionOfIssuesData{get;set;}
        public DataSet issuesBySeverityData{get;set;}
        public List<DataSet> issuesByImpactAreaData{get;set;}
        public DataSet issuesDataPrivacyData{get;set;}
        public DataSet issuesByBestPracticesData{get;set;}
        public DataSet configurationElementsData{get;set;}
    }
    
    public class DataSet{
        public String lables{get;set;}
        public String groupLables{get;set;}
        public List<Decimal> values{get;set;}
    }
    
    private List<Dataset__c> sortDatasetcListByLabel(List<Dataset__c> dList) {
        dwList = new List<DatasetcWrapper>();
        for (Dataset__c d: dList){
            dwList.add(new DatasetcWrapper(d));
        }
        dwList.sort();
        List<Dataset__c> sortedList = new  List<Dataset__c>();
        for (DatasetcWrapper dw: dwList){
            sortedList.add(dw.getDatasetc());
        }
        return sortedList;
    }
  
    public DataWrapper getData(){
        
        if (!getAPIKeyValid()) {
            return null;
        }
        if (data!=null){
            return data;

        } else {
            data = new DataWrapper ();
            
            List <Dashboard_Data__c> dataNumbers = [SELECT 
                                                    Id, 
                                                    CreatedDate,
                                                    Total_Issues__c, 
                                                    Total_Issues_Variation__c, 
                                                    Technical_Debt__c, 
                                                    Technical_Debt_Variation__c, 
                                                    Customization_Ratio__c, 
                                                    Code_Changes_Issues_Ratio__c, 
                                                    QoC__c, 
                                                    QoC_Variation__c, 
                                                    Scan_Date__c, 
                                                    Scan_ID_External__c, 
                                                    Instance_Description__c, 
                                                    Environment__c, 
                                                    Org_URL__c, 
                                                    Org_Edition__c, 
                                                    Org_Id__c
                                                    FROM Dashboard_Data__c
                                                    ORDER BY CreatedDate DESC
                                                    LIMIT 1
                                                   ];

            if (!dataNumbers.isEmpty()) {
                data.numbers = dataNumbers[0];
            }                 
            if (data.numbers?.Id != null){
                for (Chart__c chart: [SELECT Name, 
                                            Dashboard_Data__c,
                                            (SELECT Group_Label__c, Label__c, Value__c FROM Datasets__r 
                                                ORDER BY Value__c 
                                                DESC NULLS LAST) 
                                      FROM Chart__c 
                                      WHERE Dashboard_Data__c =: data.numbers.Id])
                {
                    addChartToData (chart);                   
                }
            }           
            return data;
        }
    }

    private void addChartToData (Chart__c chart){
        if (chart.Name == DashboardControllerHelper.CHART_NAME_IBP){
            data.issuesByBestPracticesData = chartToDataset(chart, null, ITEMS_TO_SHOW);
        } else if (chart.Name == DashboardControllerHelper.CHART_NAME_EOI){
            data.evolutionOfIssuesData = new List<DataSet>();
            data.evolutionOfIssuesData.add(chartToDataset(chart, DashboardControllerHelper.GROUP_LABEL_ISSUES, 0));
            data.evolutionOfIssuesData.add(chartToDataset(chart, DashboardControllerHelper.GROUP_LABEL_TECH_DEBT, 0));
        } else if (chart.Name == DashboardControllerHelper.CHART_NAME_IIA){
            data.issuesByImpactAreaData = new List<DataSet>();
            data.issuesByImpactAreaData.add(chartToDataset(chart, null, 0));
        } else if (chart.Name == DashboardControllerHelper.CHART_NAME_IDP){
            data.issuesDataPrivacyData = chartToDataset(chart, null, 0);
        } else if (chart.Name == DashboardControllerHelper.CHART_NAME_IBS){
            data.issuesBySeverityData = chartToDataset(chart, null, 0);
        } else if (chart.Name == DashboardControllerHelper.CHART_NAME_CE){
            data.configurationElementsData = chartToDataset(chart, null, ITEMS_TO_SHOW);
        }
    }

    private List<Dataset__c> groupExtraItems(List<Dataset__c> datasetcList, Integer itemsToShow){
        if (datasetcList.size() > itemsToShow) {
            Integer counter = 1;
            Integer otherItemsCounter = 0;
            Decimal otherItemsSum = 0;
            List<Dataset__c> tempDatasetcList = new List<Dataset__c>();
            for (Dataset__c d : datasetcList) {
                if (counter < itemsToShow) {
                    tempDatasetcList.add(d);
                } else {
                    otherItemsCounter++;
                    otherItemsSum += d.Value__c;
                }
                counter++;
            }
            if (otherItemsCounter > 0) {
                tempDatasetcList.add(new Dataset__c (
                    Group_Label__c = datasetcList[0].Group_Label__c,
                    Value__c = otherItemsSum,
                    Label__c = 'Other ' + otherItemsCounter + ' items'
                ));
            }               
            datasetcList = tempDatasetcList;
        }
        return datasetcList;
    }
    
    private DataSet chartToDataset (Chart__c chart, String groupLabel, Integer itemsToShow){
        DataSet chartDataSet  = new DataSet();
        List<String> lablesList = new List<String>();
        List<String> groupLablesList = new List<String>();
        List<Decimal> valuesList = new List<Decimal>();
        List<Dataset__c> datasetcList;
        if (groupLabel!=null) {
            datasetcList = sortDatasetcListByLabel(chart.Datasets__r);
        } else {
            datasetcList = chart.Datasets__r;
        }

        if (itemsToShow > 0) {
            datasetcList = groupExtraItems(datasetcList, itemsToShow);
        }
        for (Dataset__c dataRow : datasetcList){
            if ((groupLabel == dataRow.Group_Label__c)||(dataRow.Group_Label__c == '')){
                lablesList.add( String.escapeSingleQuotes(dataRow.Label__c));
                valuesList.add(dataRow.Value__c);
                groupLablesList.add(dataRow.Group_Label__c);
            }            
        }
        chartDataSet.lables = JSON.serialize(lablesList);
        chartDataSet.groupLables = JSON.serialize(groupLablesList);        
        chartDataSet.values = valuesList;
        return chartDataSet;
    }  
        
    public Boolean getAPIKeyValid(){       
        return ControllerHelperQC.checkAPIKEY();
    }

    public Boolean getCheckIfOrgConnected(){   
        return ControllerHelperQC.checkIfOrgConnected();   
    }
    
    public PageReference updateDataFromPortal (){
        
        try {
            String currentOrgId = UserInfo.getOrganizationId();
            PermissionChecker.exceptionIfNotAccessible(Instance__c.getSObjectType());
            List<Instance__c> instancesForCurrentOrg = [SELECT Id__c, Inst_Org_Id__c FROM Instance__c WHERE Inst_Org_Id__c =: currentOrgId];            
            String instanceId;
            if (instancesForCurrentOrg.size() == 1) {
                instanceId = instancesForCurrentOrg[0].ID__c;
            } else if ( instancesForCurrentOrg.size() < 1 ){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, MSG_ORG_NOT_CONNECTED));
                return null;
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, MSG_MORE_THAN_ONE_INST));
                return null;
            }
            DashboardControllerHelper helper = new DashboardControllerHelper();
            Datetime lastScanDate = getdata()?.numbers?.Scan_Date__c;     
            String result = helper.updateDataFromPortal(instanceId, lastScanDate);    
            if (result == 'OK') {
                message_type_out = 'confirm';
                message_out = MSG_UPDATED_OK;
                PageReference tempPage = new PageReference('/apex/Dashboard');
                tempPage.getParameters().put('message_type', message_type_out);
                tempPage.getParameters().put('message', message_out);
                tempPage.setRedirect(true);
                return tempPage;
            } else {
                ApexPages.getMessages().clear();
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, result));
                return null;
            }        
        } catch (Exception e) {    
            System.debug(LoggingLevel.Error, e.getStackTraceString());    
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage() + ', ' + e.getCause()));
            return null;
        }
    }  
}