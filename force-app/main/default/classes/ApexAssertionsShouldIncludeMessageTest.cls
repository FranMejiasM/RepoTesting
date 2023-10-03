@isTest
public with sharing class ApexAssertionsShouldIncludeMessageTest {
    @IsTest
    static void testMethod() {
        system.assertEquals(true, true);
    }
}