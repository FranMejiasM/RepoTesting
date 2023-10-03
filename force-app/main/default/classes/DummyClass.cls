/**
 * @description DummyClass
 */
    public with sharing class DummyClass {
    public Integer anotherField; // bad

    /**
     * @description Contructor
     */

    public DummyClass() {
        anotherField =3;
    }
    
    /**
     * @description dummy Method
     * @return void
     */    private void myDummyMethod(Integer parameterOne) {
        system.debug(parameterOne);
    }
}
