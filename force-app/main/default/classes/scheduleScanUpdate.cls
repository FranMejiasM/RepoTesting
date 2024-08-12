public class scheduleScanUpdate implements Schedulable {

    private Integer pollsLeft;  
    
    public scheduleScanUpdate(Integer pollsLeft) {
        this.pollsLeft = pollsLeft;
    }
    
    public void execute(SchedulableContext context) {
        System.abortJob(context.getTriggerId());
        System.enqueueJob(new queuedScanUpdate(pollsLeft));
    }
}