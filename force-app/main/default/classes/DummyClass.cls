/**
 * @description DummyClass
 */
    public with sharing class DummyClass {
    /**
     * @description Contructor
     */
    public Integer instanceProperty { get; set; } // bad

    /**
     * @description Contructor
     */

    public DummyClass() {
        anotherField =3;
    }
    
    /**
     * @description dummy Method
     */   
     private void myDummyMethod() {

        String LocalVariable;
        system.debug(LocalVariable);
    }
}
