public class IssuesCompactJSON2Apex {

	public List<Trend> trend;
	public Double variation;
	public Boolean inverseVariation;
	public Double value;
	public Double average;
	public Double issuesWrittenOff;
	public Double previous;
	public Double baseline;
	public Double dataPrivacy;
	public Double bespokeRules;
	public Double defaultNamespace;
    public Double numGlobal;
    public Double configurationRatio;
	public Double benchmark;
	public List<NumIssuesByGroupType> numIssuesByGroupType;
	public Integer sensitive;
	public Integer extraSensitive;
	public Integer privateIssues;

	public class Trend {
		public List<Data> data;
		public String name;
	}

	public class Data {
		public Integer scanId;
		public String label;
		public String value;
	}

	public class NumIssuesByGroupType {
		public String label;
		public String value;
	}

	
	public static IssuesCompactJSON2Apex parse(String json) {
		return (IssuesCompactJSON2Apex) System.JSON.deserialize(json, IssuesCompactJSON2Apex.class);
	}
}