// CONTROL - parecido pero no colisiona
public class FbFooService {
    public void run(List<Id> ids) {
        for (Id i : ids) {
            List<Account> accs = [SELECT Id FROM Account WHERE Id = :i];
            System.debug(accs);
        }
        try {
            Integer x = 1 / 0;
        } catch (Exception e) {
        }
    }
}
