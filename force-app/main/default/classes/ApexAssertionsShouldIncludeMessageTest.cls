@isTest
public with sharing class ApexAssertionsShouldIncludeMessageTest {
    @IsTest
    static void testMethod() {
system.debug('hello');
        system.assertEquals(true, true);
    }
}