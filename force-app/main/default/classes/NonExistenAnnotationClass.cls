/**
* @description dummy Method 3
*/   
public with sharing class NonExistenAnnotationClass {
    /**
    * @description dummy Method
    */   
    @fakeAnnotation
    public void dummyMethod(){      
        System.debug('Dummy');
    }
}
