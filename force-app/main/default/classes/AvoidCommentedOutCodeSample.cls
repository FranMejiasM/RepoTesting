/**
 * ApexDoc is not reported, even with code in it:
 * Integer x = 1;
 */
public with sharing class AvoidCommentedOutCodeSample {

    public void process(Account acc) {
        // acc.Name = 'Test';
        // update acc;
        Integer a = 1;
        /* if (acc.Industry == null) {
            acc.Industry = 'Other';
        } */
        a = 2; // a = 3;
        // Old logic, kept for reference:
        // System.debug(acc);
        /*
         * List<Account> accs = [SELECT Id FROM Account];
         */
        //for (Integer i = 0; i < 10; i++)

        // Updates the account name before saving it.
        // TODO: call validate(acc);
        // FIXME remove this; it is slow
        a = 4; // the counter is increased later
        /* Prose block comment
           explaining what happens next; nothing else
           and a third line */
        String s = '// not a comment;';
        // See the Trigger Framework section of the wiki
        // for the details of the order of execution
    }

    /**
     * Returns the accounts of an industry.
     * Example: List<Account> accs = byIndustry('Energy');
     */
    public List<Account> byIndustry(String industry) {
        //return [SELECT Id FROM Account];
        return [SELECT Id FROM Account WHERE Industry = :industry];
    }
}
