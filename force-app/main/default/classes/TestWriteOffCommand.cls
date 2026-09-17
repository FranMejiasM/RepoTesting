public with sharing class TestWriteOffCommand {
    /**
     * @description dummy Method
     */   
     private void myDummyMethod() {
      for(integer i=1; i<10;i++)  {
         Account a = [SELECT ID FROM Account];
      }
      for(integer i=1; i<10;i++)  {
         Contact c = [SELECT ID FROM Contact];
      }
        String LocalVariable;
        system.debug(LocalVariable);
    }
}