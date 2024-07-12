/**
* @description dummy Method
*/   
public with sharing class OperationsInLoops {
/**
* @description dummy Method
*/   
    public void messageInsideOfLoop() {
        List<Messaging.SingleEmailMessage> lstEmails = new List<Messaging.SingleEmailMessage>();

        for (Integer i = 0; i < 10; i++) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            lstEmails.add(email);
            
        }
        Messaging.sendEmail(lstEmails);
    }
}