@IsTest
public class QualityOfCloudTrendJSON2Apex_Test {
	
	static testMethod void testParse() {
		String json = '{\"trend\":[{\"data\":[{\"scanId\":9980,\"label\":\"2021-04-14T08:26:42Z\",\"value\":\"13.0\"},{\"scanId\":9981,\"label\":\"2021-04-14T08:28:27Z\",\"value\":\"13.0\"},{\"scanId\":9985,\"label\":\"2021-04-15T11:22:31Z\",\"value\":\"13.0\"}],\"name\":\"Quality of Cloud Trend\"}],\"variation\":0.0,\"inverseVariation\":false,\"value\":[{\"data\":[{\"label\":\"2021-04-15T11:22:31Z\",\"value\":\"13.0\"}],\"name\":\"Quality of Cloud\"}],\"average\":73,\"baseline\":13.0,\"hasQocV2\":false}';
		QualityOfCloudTrendJSON2Apex obj = QualityOfCloudTrendJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}