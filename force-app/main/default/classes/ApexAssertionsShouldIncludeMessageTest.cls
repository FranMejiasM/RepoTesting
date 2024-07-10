@isTest
public with sharing class ApexAssertionsShouldIncludeMessageTest {
    @IsTest
    static void myTest() {
        system.assertEquals(true, true);
    }
}