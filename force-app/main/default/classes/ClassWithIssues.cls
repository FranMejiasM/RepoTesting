public class ClassWithIssues {
     private void myDummyMethod() {

         for(Integer i=0; i<500; i++) {
             Account acc = [SELECT Id from Account];
         }
    }
}