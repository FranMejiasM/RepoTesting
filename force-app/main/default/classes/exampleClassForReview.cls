public class exampleClassForReview {
    public void dontDoThis() {
        String myName = 'dummy';
		Integer length = 1000;            
        for (Integer i = 0; i < length; i++) {
            Account acc = [SELECT Id FROM Account WHERE Name = :myName];        
    	}
        system.debug('24/10/2024 11:40');
    }
}