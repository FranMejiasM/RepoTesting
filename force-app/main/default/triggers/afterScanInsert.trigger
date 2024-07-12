trigger afterScanInsert on Scann__c (after insert) {
    Integer numberOfPolls = 25;
    try {
        numberOfPolls = Integer.valueOf([SELECT DeveloperName, Setting_Value__c 
                            FROM QualityCloudsPollingSettings__mdt 
                            WHERE DeveloperName = 'Number_of_Polls' 
                            LIMIT 1].Setting_Value__c);
        System.debug('Number of Polls from Custom Metadata: ' + numberOfPolls);
    } catch (Exception e) {
        System.debug(LoggingLevel.Error, e.getStackTraceString()); 
        System.debug('An error occurred: ' + e.getMessage());
        System.debug('Error occured during getting Number of Polls from Custom Metadata. Default value of 25 polls is used.');
    }
    
    if (numberOfPolls > 0) {
        System.enqueueJob(new queuedScanUpdate(numberOfPolls));
    }
}