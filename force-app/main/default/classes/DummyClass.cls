/**
 * @description DummyClass
 */
    public with sharing class DummyClass {
    /**
     * @description Contructor
     */
    public Integer PROPERTY { get; set; } // bad

    /**
     * @description Contructor
     */

    public DummyClass() {
        anotherField =3;
    }
    
    /**
     * @description dummy Method
     */   
     private void MyDummyMethod() {

        String Localvariable;
        system.debug(Localvariable);
    }
}
