/**
* @description dummy Class
*/   
public with sharing class OverrideBothEqualsAndHashcodeClass {
    /**
    * @description dummy method 3
    */   
    public Boolean equals(Object o) {
        System.debug('Dummy');
        return true;
      }
}