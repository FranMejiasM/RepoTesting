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
        system.assertEquals(true,true, 'msg');                           
        test.stopTest();
    }
}
