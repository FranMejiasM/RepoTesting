@isTest
public with sharing class ApexAssertionsShouldIncludeMessageTest {
    @testMethod
    static void testMethod() {
        system.assertEquals(true, true);
    }
}