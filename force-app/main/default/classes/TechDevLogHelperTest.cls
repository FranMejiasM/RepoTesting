@isTest
private class TechDevLogHelperTest {
    
    @isTest
    private static void logException() {
        try {
            Account acc;
            acc.Name = 'This will throw null pointer exception';
        }
        catch (Exception e) {
            TechDevLogHelper.logException(e);
        }

        List<Tech_DevLog__c> logs = [SELECT Id FROM Tech_DevLog__c];
        System.assertEquals(1, logs.size());
    }

    @isTest
    private static void log() {
        TechDevLogHelper.log('subject', 'log', 'traceGroup');

        List<Tech_DevLog__c> logs = [SELECT Id, Subject__c, Log__c, traceGroup__c FROM Tech_DevLog__c];
        System.assertEquals(1, logs.size());
        System.assertEquals('subject', logs[0].Subject__c);
        System.assertEquals('log', logs[0].Log__c);
        System.assertEquals('traceGroup', logs[0].traceGroup__c);
    }

    @isTest
    private static void generateRandomString() {
        String randStr = TechDevLogHelper.generateRandomString(8);

        System.assert(String.isNotBlank(randStr));
        System.assertEquals(8, randStr.length());
    }

    @isTest
    private static void logCallout() {
        Tech_DevLog__c log = new Tech_DevLog__c();

        TechDevLogHelper.logCallout(log);

        List<Tech_DevLog__c> logs = [SELECT Id FROM Tech_DevLog__c];
        System.assertEquals(1, logs.size());
    }

    
    @isTest
    private static void logCalloutFuture() {
        Tech_DevLog__c log = new Tech_DevLog__c();

        TechDevLogHelper.logCallout(log);

        List<Tech_DevLog__c> logs = [SELECT Id FROM Tech_DevLog__c];
        System.assertEquals(1, logs.size());
    }

    @isTest
    private static void logCallout_error() {
        Tech_DevLog__c log = new Tech_DevLog__c();
        test.startTest();
        TechDevLogHelper.logCalloutFuture('a', 'a', 'a',100); 
        test.stopTest();
        
        List<Tech_DevLog__c> logs = [SELECT Id FROM Tech_DevLog__c];
        System.assertEquals(1, logs.size());
    }
}