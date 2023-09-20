@isTest
public with sharing class dummyclassTest {

    private static testMethod void testMethod1(){
        test.startTest();
        system.debug('1');
        system.assertEquals(true,true);                           
        test.stopTest();
    }
}
