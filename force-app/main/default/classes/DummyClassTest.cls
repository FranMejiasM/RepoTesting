/**
 * @description DummyClass Test
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
}
