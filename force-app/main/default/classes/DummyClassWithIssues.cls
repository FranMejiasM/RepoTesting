public class DummyClassWithIssues {
    Account acc = [select id, name, createddate from account limit 1];
    public void myMethod() {
    	system.debug('HELLO, THIS IS A CHANGE! COMMIT IT');
    }
}