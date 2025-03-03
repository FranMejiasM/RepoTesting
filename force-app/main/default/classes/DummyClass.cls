/**
 * @description DummyClass 3
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
       Integer anotherField =3;
    }
     
     private void myDummyMethod() {
      for(integer i=1; i<10;i++)  {
         Account a = [SELECT ID FROM Account];
      }
      for(integer j=1; j<10;j++)  {
         Contact a = [SELECT ID FROM Contact];
      }
      for(integer k=1; k<10;k++)  {
         Case a = [SELECT ID FROM Case];
      }
      for(integer l=1; l<10;l++)  {
         Opportunity a = [SELECT ID FROM Opportunity];
      }
        String LocalVariable;
        system.debug(LocalVariable);
    }
}
