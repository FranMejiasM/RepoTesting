@IsTest
public class IssuesCompactJSON2Apex_Test {
	
	static testMethod void testParse() {
		String json = '{"trend":[{"data":[{"scanId":9980,"label":"2021-04-14T08:26:42Z","value":"400"},{"scanId":9981,"label":"2021-04-14T08:28:27Z","value":"400"},{"scanId":9985,"label":"2021-04-15T11:22:31Z","value":"400"}],"name":"Issues Over Time Trend"}],"variation":0.0,"inverseVariation":true,"value":400,"average":1762,"issuesWrittenOff":0,"previous":400,"baseline":400,"dataPrivacy":0,"bespokeRules":0,"defaultNamespace":225,"numIssuesByGroupType":[{"label":"Apex","value":"392"},{"label":"others","value":"8"}]}';
		IssuesCompactJSON2Apex obj = IssuesCompactJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}