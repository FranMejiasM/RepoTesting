/**
 * @description InaccesiblrAuraGetterClass
 */
public with sharing class InaccesiblrAuraGetterClass {
    @AuraEnabled
    /**
    * @description getter
    */
    public Integer counter { public get; set; } 

    @AuraEnabled
    /**
    * @description method
    */
    public static InaccesiblrAuraGetterClass bar()
    {
        InaccesiblrAuraGetterClass foo = new InaccesiblrAuraGetterClass();
        foo.counter = 2; 
        return foo;
    }
}