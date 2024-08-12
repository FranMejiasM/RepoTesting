@isTest
public with sharing class ApexAssertionsShouldIncludeMessageTest {
    @IsTest
    static void testMethod() {
system.debug('hello');
        system.assertEquals(true, true);
    }

    @IsTest
    static void myTest2() {
        system.assertEquals(true, true);
    }
} 