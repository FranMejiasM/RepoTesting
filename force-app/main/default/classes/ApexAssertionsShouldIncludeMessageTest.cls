@isTest
public with sharing class ApexAssertionsShouldIncludeMessageTest {
    @IsTest
    static void testMethod() {
        system.assertEquals(true, true);
    }
    @IsTest
    static void testMethod2() {
        system.assertEquals(true, true);
    }
}