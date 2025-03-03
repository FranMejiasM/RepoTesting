public with sharing class InaccesiblrAuraGetterClass {
    @AuraEnabled
    public Integer counter { private get; set; } // Violating - Private getter is inaccessible to Lightning components

    @AuraEnabled
    public static InaccesiblrAuraGetterClass bar()
    {
        InaccesiblrAuraGetterClass foo = new InaccesiblrAuraGetterClass();
        foo.counter = 2; 
        return foo;
    }
}