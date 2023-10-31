/**
 * @description       : Controller class for lwc instance detail
 * @author            : Fran Mejías
 * @group             : 
 * @last modified on  : 20-06-2023
 * @last modified by  : Fran Mejías
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   20-06-2023   Fran Mejías   Initial Version
**/
public with sharing class InstanceDetailControllerLWC {
    
    /**
    * @description Execute a scan for a branch
    */
    @AuraEnabled
    public static Map<String,Object> executeScan(String instanceId, String idc, String gitBranch) {
        Map<String,Object> response = new Map<String,Object>();
        String result;
       Instance__c instance = new Instance__c(Id = instanceId, ID__c = idc);

        try {
            globalCallsToQC exec = new globalCallsToQC();
            result = exec.execute_scann(instance, gitBranch, true);

            switch on result {
                when 'Success' {
                    response.put('isSuccess', 'OK');
                    response.put('message', 'Scan launched.');
                }
                when 'Delay' {
                    response.put('isSuccess', 'WARN');
                    response.put('message', 'There are to many scans running on the same branch, please try again later.');
                }
                when else {
                    response.put('isSuccess', 'ERR');
                    response.put('message', 'We could not run the scan. Please contact your administrator.');
                }
            }
        }
        catch(Exception e) {
            throw newException(e.getMessage());
        }           
        return response;
    }

        /**
    * @description Retrieve all the scans related to an instance
    */
    @AuraEnabled
    public static List<scanWrapper> getScans(String instanceId) {
        List<scanWrapper> result = new List<scanWrapper>();
        for(Scann__c scan : [SELECT Id, Date__c, State__c, Branch_Name__c FROM Scann__c WHERE Instance__c = :instanceId ORDER BY Date__c DESC]) {
            scanWrapper wrap = new scanWrapper();

            wrap.scanDate = scan.Date__c.format();
            wrap.Branch = scan.Branch_Name__c;
            wrap.scanId = scan.Id;
            wrap.State = scan.State__c;
            result.add(wrap);
        }            
        return result;
    }

    /**
    * @description Retrieve IDC from the instance
    */
    @AuraEnabled
    public static string getInstanceId(Id instanceId) {
        String response = null; 
        
        List<Instance__c> instance = [SELECT ID__c FROM Instance__c WHERE Id = :instanceId LIMIT 1]; 

        if (!instance.isEmpty()) {
          response = instance[0].ID__C; 
        } 
        return response;
    }

    /**
    * @description Retrieve NAMESPACE of the ORG
    */
    @AuraEnabled
    public static string getNamespaceOrg() {
        
        string response = [SELECT NamespacePrefix FROM Organization].NamespacePrefix;
        
        return response;
    }

    private static AuraHandledException newException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }        

    public class scanWrapper {
        @AuraEnabled public String scanDate {get;set;}
        @AuraEnabled public String Branch {get;set;}
        @AuraEnabled public String State {get;set;}
        @AuraEnabled public String scanId {get;set;}
        }
}