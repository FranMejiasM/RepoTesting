public with sharing class DataDataJSON2Apex {
    public List<Data_Z> data;

	public class Data_Z {
		public List<Data> data;
		public String name;
	}

	public class Data {
		public Integer scanId;
		public String label;
		public Integer value;
	}
	
	public static DataDataJSON2Apex parse(String json) {
		return (DataDataJSON2Apex) System.JSON.deserialize(json, DataDataJSON2Apex.class);
	}
}