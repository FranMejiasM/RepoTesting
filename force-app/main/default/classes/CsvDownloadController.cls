public with sharing class CsvDownloadController {
    public String input {get;set;}
    public String fileName {get;set;}
    public CsvDownloadController() {
        String id_scan = ApexPages.currentPage().getParameters().get('id');
        Scann__c scan = [SELECT Branch_Name__c, Date__c, Duration__c, ID__c, Instance__c, Scan_Type__c, Quality_of_Cloud__c, Configuration_Elements__c, State__c, Technical_Debt_hours__c, Total_Issues__c, Id  FROM Scann__c WHERE ID__c = :id_scan ORDER BY CreatedDate DESC];
        List<QCIssue__c > issuelist = [SELECT Created_By__c, Created_On__c, Element_Name__c, Link_to_Element__c, Documentation__c, Element_Type__c, ID__c, Impact_Area__c, Issue__c, Line_Number__c, Link__c, Scan__c, Severity__c, Updated_By__c, Updated_On__c, Id FROM QCIssue__c WHERE Scan__c = :scan.Id];
        string header = 'Scan Date;Affected Element SysId;Affected Element Name;Created By;Created On;Updated By;Updated On;Severity;Impact Area;Issue Type;Line Number;Best Practice Link;Configuration Element Type\n';
        input = header ;
        fileName = 'scan_'+scan.ID__c;
        for(QCIssue__c isue: issuelist)
        {

            string recordString = scan.Date__c+';'+isue.Link_to_Element__c+';'+isue.Element_Name__c+';'+isue.Created_By__c+';'+isue.Created_On__c+';'+isue.Updated_By__c+';'+isue.Updated_On__c+';'+isue.Severity__c+';'+isue.Impact_Area__c+';'+isue.Issue__c+';'+isue.Line_Number__c+';'+isue.Documentation__c+';'+isue.Element_Type__c +'\n';

            input = input +recordString;

        }
    }

}