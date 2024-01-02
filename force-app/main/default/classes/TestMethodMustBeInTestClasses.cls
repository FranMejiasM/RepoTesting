public with sharing class TestMethodMustBeInTestClasses {
    
    @IsTest
    static void methodName(){    
        User u = [SELECT Id FROM User LIMIT 1];     
        Test.startTest();
        System.runAs(u) {
            system.assertEquals(true, true, 'Hi');
        }
        Test.stopTest();    
    }
    
}