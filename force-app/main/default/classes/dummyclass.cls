/**
 * @description dummyclass
 */
    public with sharing class dummyclass {
    public Integer anotherField; // bad

    /**
     * @description Contructor
     */

    public dummyclass() {
        anotherField =3;
    }
    
    /**
     * @description dummy Method
     * @return void
     */    private void myDummyMethod(Integer parameterOne) {
        system.debug(parameterOne);
    }
}