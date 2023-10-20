/**
* @description dummy Class
*/   
public with sharing class OverrideBothEqualsAndHashcodeClass {
    /**
    * @description dummy method
    */   
    public Boolean equals(Object o) {
        System.debug('Dummy');
        return true;
      }
    /**
    * @description dummy method
    */ 
    public Integer hashCode() {
        return 1; 
    }
}