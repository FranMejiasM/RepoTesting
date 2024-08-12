
public with sharing class OperationsInLoops {
    public void messageInsideOfLoop2() {
        for (Integer i = 0; i < 10; i++) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            lstEmails.add(email);
            
        }
        Messaging.sendEmail(lstEmails);
    }
}