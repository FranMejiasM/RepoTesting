/**
* @description dummy Method
*/   
public with sharing class OperationsInLoops {
/**
* @description dummy Method
*/   
    public void messageInsideOfLoop() {
        for (Integer i = 0; i < 10; i++) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        }
    }
}