public class FranAPexWIthISsues {
    public static Integer countAccounts(List<String> searchTerms) {
        Integer totalFound = 0;
        for (String searchTerm : searchTerms) {
            List<List<SObject>> searchResults = [FIND :searchTerm IN ALL FIELDS RETURNING Account(Id, Name)];
            totalFound += searchResults[0].size();
        }

        String x;
        Integer y = 0;
        y+=7;
        y-=7;
        String myCumple = '2024-01-01T10:00:00Z';   
        DateTime fecha1 = DateTime.valueOf('2024-01-01T10:00:00Z');
        Date fecha = Date.valueOf('01/01/2030');
        Date fecha2 = Date.valueOf('2030-31-31');

        Date mal = Date.valueOf('2024-01-01');

        Date bien = Date.newInstance(2024, 1, 1);

        List<Account> accounts = [SELECT Id, Name FROM Account WHERE CreatedDate = 2024-01-01T10:00:00Z];    
        
        return totalFound;
    }
}