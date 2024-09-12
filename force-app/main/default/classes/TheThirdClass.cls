public class TheThirdClass {
    public void dontDoThis() {
        String myName = 'dummy';
		Integer length = 1000;            
        for (Integer i = 0; i < length; i++) {
            Account acc = [SELECT Id FROM Account WHERE Name = :myName];        
    	}
        system.debug('27/10/2023 11:40');
    }
}