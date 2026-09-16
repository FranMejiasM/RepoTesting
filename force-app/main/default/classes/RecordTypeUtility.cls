public class RecordTypeUtility {

    public static Id getAccountRecordTypeIdByName(String recordTypeName) {
        // Get the describe result for the Account object
        Schema.DescribeSObjectResult accountDescribe = Account.sObjectType.getDescribe();
        
        // Get the map of record type infos by name
        Map<String, Schema.RecordTypeInfo> rtInfoByName = accountDescribe.getRecordTypeInfosByDeveloperName();
        
        // Check if the record type exists to avoid null pointer exceptions
        if (rtInfoByName.containsKey(recordTypeName)) {
            Schema.RecordTypeInfo rtInfo = rtInfoByName.get(recordTypeName);
            
            // Verify the record type is active and available to the context user
            if (rtInfo.isActive() && rtInfo.isAvailable()) {
                return rtInfo.getRecordTypeId();
            }
        }
        
        return null;
    }

    public static void createAccountWithSpecificRecordType(String accountName, String recordTypeName) {
        Id targetRecordTypeId = getAccountRecordTypeIdByName(recordTypeName);
        
        if (targetRecordTypeId != null) {
            System.debug('Account created successfully with Record Type ID: ' + targetRecordTypeId);
        } else {
            System.debug('Record Type not found or not active: ' + recordTypeName);
        }
    }
}