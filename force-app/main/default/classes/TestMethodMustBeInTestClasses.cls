public with sharing class TestMethodMustBeInTestClasses {
    
    @IsTest
    static void methodName(){        
        Test.startTest();
        system.debug('dummy');
        Test.stopTest();    
    }
    
}