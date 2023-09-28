public with sharing class dummyclass {
    public Integer anotherField; // bad

    public dummyclass() {
        anotherField =3;
    }

    private void myDummyMethod(Integer parameterOne) {
        system.debug(parameterOne);
    }
}