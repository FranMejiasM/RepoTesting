/**
 * @description DummyClass Test 1
 */
@isTest
public with sharing class DummyClassTest {

    /**
     * @description dummy testMethod1
     * @return void
     */ 
    @isTest
    private static void testMethod1(){
        test.startTest();
        system.debug('1');
        Boolean uNUSEDVAR;
    
        system.assertEquals(true,true);                           
        test.stopTest();
    }

    @isTest
    private static void testMethod2(){
        test.startTest();
        system.debug('1');
        Boolean uNUSEDVAR;
    
        test.stopTest();
    }
}
