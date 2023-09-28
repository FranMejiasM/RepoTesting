@isTest
public with sharing class dummyclassTest {

    @isTest
    private static void testMethod1(){
        test.startTest();
        system.debug('1');
        system.assertEquals(true,true, 'msg');                           
        test.stopTest();
    }
}
