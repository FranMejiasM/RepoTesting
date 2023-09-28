public with sharing class dummyclass {
    public dummyclass() {
        anotherField =3;
    }

    public Integer AnotherField; // bad

    private void myDummyMethod(Integer Parameter1) {
        system.debug(Parameter1);
    }
}