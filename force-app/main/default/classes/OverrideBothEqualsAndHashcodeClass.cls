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
}