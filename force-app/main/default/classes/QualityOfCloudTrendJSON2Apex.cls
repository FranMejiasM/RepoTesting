public class QualityOfCloudTrendJSON2Apex {

	public List<Trend> trend;
	public Double variation;
	public Boolean inverseVariation;
	public List<Value> value;
	public Double average;
	public Double baseline;

	public class Data_Z {
		public String label;
		public Double value;
	}

	public class Trend {
		public List<Data> data;
		public String name;
	}

	public class Value {
		public List<Data_Z> data;
		public String name;
	}

	public class Data {
		public Integer scanId;
		public String label;
		public Double value;
	}

	
	public static QualityOfCloudTrendJSON2Apex parse(String json) {
		return (QualityOfCloudTrendJSON2Apex) System.JSON.deserialize(json, QualityOfCloudTrendJSON2Apex.class);
	}
}