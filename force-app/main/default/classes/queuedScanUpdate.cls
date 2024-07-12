public class queuedScanUpdate implements Queueable, Database.AllowsCallouts {

    private Integer pollsLeft;

    public queuedScanUpdate(Integer pollsLeft) {
        this.pollsLeft = pollsLeft;
    }

    public void execute(QueueableContext context) {
        if(pollsLeft >= 0 && [SELECT count() FROM Scann__c WHERE State__c = 'RUNNING'] > 0 ){  
            boolean scanIsDone = ControllerHelperQC.updateScannsPolling(pollsLeft);
            --pollsLeft;
            // start keepalive again in x mins
            Datetime sysTime = System.now().addSeconds(70);
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            String randomStr = ControllerHelperQC.generateRandomString(9, false);
            System.schedule( 'scheduleScanUpdate ' + sysTime + ' ' + randomStr, chronExpression, new scheduleScanUpdate(pollsLeft) );
        }
    }
}