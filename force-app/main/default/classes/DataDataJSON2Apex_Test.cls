@IsTest
public class DataDataJSON2Apex_Test {
	
	static testMethod void testParse() {
		String json = '{\"data\":[{\"data\":[{\"scanId\":9980,\"label\":\"2021-04-14T08:26:42Z\",\"value\":\"604\"},{\"scanId\":9981,\"label\":\"2021-04-14T08:28:27Z\",\"value\":\"604\"},{\"scanId\":9985,\"label\":\"2021-04-15T11:22:31Z\",\"value\":\"604\"}],\"name\":\"Issues Over Time\"}]}';
		DataDataJSON2Apex obj = DataDataJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}