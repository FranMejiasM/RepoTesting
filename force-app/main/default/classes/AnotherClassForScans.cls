public without sharing class AnotherClassForScans {
    public void myMEthod() {
        for(Account acc : [select id from Account]) {
            system.debug('do something new');
        }
    }
}