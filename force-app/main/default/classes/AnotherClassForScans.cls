public without sharing class AnotherClassForScans {
    public void myMEthod() {
        for(Account acc : [select id from Account]) {
            List<Account> acc2 = [select id from Account];
            system.debug('do something new');
        }
    }
}