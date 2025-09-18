// FeatureParameterTableCtrl.cls
public with sharing class FeatureParameterTableCtrl {
    @AuraEnabled(cacheable=true)
    public static List<sfFma__FeatureParameterBoolean__c> getParams() {
        return [
            SELECT Id,
                   sfFma__Value__c,
                   sfFma__FeatureParameter__r.sfFma__FullName__c,
                   sfFma__License__r.sfLma__Package_Version__r.sfLma__Package__r.Name,
                   sfFma__License__r.sfLma__Package_Version__r.sfLma__Version_Number__c,
                   sfFma__License__r.sfLma__Package_Version__r.sfLma__Is_Beta__c,
                   sfFma__License__r.sfLma__Lead__r.Name,
                   sfFma__License__r.sfLma__Lead__r.Company,
                   sfFma__License__r.sfLma__Subscriber_Org_ID__c,
                   sfFma__License__r.sfLma__Is_Sandbox__c,
                   sfFma__License__r.sfLma__Lead__r.sfLma__Subscriber_Org_Type__c,
                   sfFma__License__r.sfLma__Status__c
            FROM sfFma__FeatureParameterBoolean__c
        ];
    }

    @AuraEnabled
    public static void updateValues(List<sfFma__FeatureParameterBoolean__c> rows) {
        // Sólo necesitamos Id + sfFma__Value__c
        List<sfFma__FeatureParameterBoolean__c> toUpdate = new List<sfFma__FeatureParameterBoolean__c>();
        for (sfFma__FeatureParameterBoolean__c r : rows) {
            toUpdate.add(new sfFma__FeatureParameterBoolean__c(
                Id = r.Id,
                sfFma__Value__c = r.sfFma__Value__c
            ));
        }
        // (Opcional para security review) aplicar FLS/CRUD
        // SObjectAccessDecision acc = Security.stripInaccessible(
        //     AccessType.UPDATABLE, toUpdate
        // );
        // update (List<sfFma__FeatureParameterBoolean__c>)acc.getRecords();

        update toUpdate;
    }
}