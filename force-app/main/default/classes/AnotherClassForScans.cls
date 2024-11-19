    /**
    * @description dummy Method
    */   
public without sharing class AnotherClassForScans {    
    /**
    * @description dummy Method
    */   
    public void myMEthod() {
        try {
            for(Account acc : [select id from Account])
            {
               String a = 'do something new';
           }   
        } catch(Exception e) {
            system.debug(e.getMessage());
        } finally {

        }
    }
}