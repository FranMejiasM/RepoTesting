/**
 * @description InaccesiblrAuraGetterClass
 */
public with sharing class EagerlyLoadedDescribeSObjectResultClass {
    /**
    * @description method
    */
    public static void bar(List<Account> accounts) {
            insert accounts;
    }
}