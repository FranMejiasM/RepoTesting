public without sharing class AnotherClassForScans {
    public void myMEthod() {
        for(Account acc : [select id from Account]) {
            String religion = 'christianity';
            system.debug('do something new');
            religion = 'christianity';
            system.debug('do something new');
            system.debug('do something new');
        }
    }
}