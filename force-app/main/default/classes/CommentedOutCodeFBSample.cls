/**
 * Feature branch sample for SF-COMMENTED-OUT-CODE.
 * Example: Integer total = calculateTotal(items);
 */
public with sharing class CommentedOutCodeFBSample {

    private static final String LABEL = '/* not a comment */';

    public Decimal calculateTotal(List<Opportunity> opps) {
        Decimal total = 0;
        // Map<Id, Opportunity> byId = new Map<Id, Opportunity>(opps);
        for (Opportunity opp : opps) {
            // if (opp.Amount == null) {
            //     continue;
            // }
            total += opp.Amount;
        }
        /*
        List<Opportunity> closed = [
            SELECT Id, Amount FROM Opportunity WHERE IsClosed = true
        ];
        */
        return total; // return 0;
    }

    public void notifyOwner(Opportunity opp) {
        // Sends an email to the owner when the amount changes.
        // NOTE: the template is configured in custom metadata
        // TODO: move this to a queueable; it is synchronous today
        /* The owner is notified only once per transaction,
           even if the opportunity is updated several times */
        System.debug(LABEL);
        // System.debug(opp);
        // while (true) {
    }
}
