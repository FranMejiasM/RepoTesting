public class MetadataService {
	
	public static String SOAP_M_URI = 'http://soap.sforce.com/2006/04/metadata';
    
    public virtual class Metadata {
        public String fullName;
    }

    public class Error {
        public MetadataService.ExtendedErrorDetails[] extendedErrorDetails;
        public String[] fields;
        public String message;
        public String statusCode;
        private String[] extendedErrorDetails_type_info = new String[]{'extendedErrorDetails',SOAP_M_URI,null,'0','-1','false'};
        private String[] fields_type_info = new String[]{'fields',SOAP_M_URI,null,'0','-1','false'};
        private String[] message_type_info = new String[]{'message',SOAP_M_URI,null,'1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'extendedErrorDetails','fields','message','statusCode'};
    }
    
    public class SaveResult {
        public MetadataService.Error[] errors;
        public String fullName;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors',SOAP_M_URI,null,'0','-1','false'};
        private String[] fullName_type_info = new String[]{'fullName',SOAP_M_URI,null,'1','1','false'};
        private String[] success_type_info = new String[]{'success',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'errors','fullName','success'};
    }

    public class ConnectedAppAttribute {
        public String formula;
        public String key;
        private String[] formula_type_info = new String[]{'formula',SOAP_M_URI,null,'1','1','false'};
        private String[] key_type_info = new String[]{'key',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'formula','key'};
    }

    public class DeleteResult {
        public MetadataService.Error[] errors;
        public String fullName;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors',SOAP_M_URI,null,'0','-1','false'};
        private String[] fullName_type_info = new String[]{'fullName',SOAP_M_URI,null,'1','1','false'};
        private String[] success_type_info = new String[]{'success',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'errors','fullName','success'};
    }

    public class ConnectedAppCanvasConfig {
        public String accessMethod;
        public String canvasUrl;
        public String lifecycleClass;
        public String[] locations;
        public String[] options;
        public String samlInitiationMethod;
        private String[] accessMethod_type_info = new String[]{'accessMethod',SOAP_M_URI,null,'1','1','false'};
        private String[] canvasUrl_type_info = new String[]{'canvasUrl',SOAP_M_URI,null,'1','1','false'};
        private String[] lifecycleClass_type_info = new String[]{'lifecycleClass',SOAP_M_URI,null,'0','1','false'};
        private String[] locations_type_info = new String[]{'locations',SOAP_M_URI,null,'0','-1','false'};
        private String[] options_type_info = new String[]{'options',SOAP_M_URI,null,'0','-1','false'};
        private String[] samlInitiationMethod_type_info = new String[]{'samlInitiationMethod',SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'accessMethod','canvasUrl','lifecycleClass','locations','options','samlInitiationMethod'};
    }

    public class ConnectedAppIpRange {
        public String description;
        public String end_x;
        public String start;
        private String[] description_type_info = new String[]{'description',SOAP_M_URI,null,'0','1','false'};
        private String[] end_x_type_info = new String[]{'end',SOAP_M_URI,null,'1','1','false'};
        private String[] start_type_info = new String[]{'start',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'description','end_x','start'};
    }

    public class ConnectedAppSamlConfig {
        public String acsUrl;
        public String certificate;
        public String encryptionCertificate;
        public String encryptionType;
        public String entityUrl;
        public String issuer;
        public String samlIdpSLOBindingEnum;
        public String samlNameIdFormat;
        public String samlSloUrl;
        public String samlSubjectCustomAttr;
        public String samlSubjectType;
        private String[] acsUrl_type_info = new String[]{'acsUrl',SOAP_M_URI,null,'1','1','false'};
        private String[] certificate_type_info = new String[]{'certificate',SOAP_M_URI,null,'0','1','false'};
        private String[] encryptionCertificate_type_info = new String[]{'encryptionCertificate',SOAP_M_URI,null,'0','1','false'};
        private String[] encryptionType_type_info = new String[]{'encryptionType',SOAP_M_URI,null,'0','1','false'};
        private String[] entityUrl_type_info = new String[]{'entityUrl',SOAP_M_URI,null,'1','1','false'};
        private String[] issuer_type_info = new String[]{'issuer',SOAP_M_URI,null,'0','1','false'};
        private String[] samlIdpSLOBindingEnum_type_info = new String[]{'samlIdpSLOBindingEnum',SOAP_M_URI,null,'0','1','false'};
        private String[] samlNameIdFormat_type_info = new String[]{'samlNameIdFormat',SOAP_M_URI,null,'0','1','false'};
        private String[] samlSloUrl_type_info = new String[]{'samlSloUrl',SOAP_M_URI,null,'0','1','false'};
        private String[] samlSubjectCustomAttr_type_info = new String[]{'samlSubjectCustomAttr',SOAP_M_URI,null,'0','1','false'};
        private String[] samlSubjectType_type_info = new String[]{'samlSubjectType',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'acsUrl','certificate','encryptionCertificate','encryptionType','entityUrl','issuer','samlIdpSLOBindingEnum','samlNameIdFormat','samlSloUrl','samlSubjectCustomAttr','samlSubjectType'};
    }

    public class ConnectedAppMobileDetailConfig {
        public String applicationBinaryFile;
        public String applicationBinaryFileName;
        public String applicationBundleIdentifier;
        public Integer applicationFileLength;
        public String applicationIconFile;
        public String applicationIconFileName;
        public String applicationInstallUrl;
        public String devicePlatform;
        public String deviceType;
        public String minimumOsVersion;
        public Boolean privateApp;
        public String version;
        private String[] applicationBinaryFile_type_info = new String[]{'applicationBinaryFile',SOAP_M_URI,null,'0','1','false'};
        private String[] applicationBinaryFileName_type_info = new String[]{'applicationBinaryFileName',SOAP_M_URI,null,'0','1','false'};
        private String[] applicationBundleIdentifier_type_info = new String[]{'applicationBundleIdentifier',SOAP_M_URI,null,'0','1','false'};
        private String[] applicationFileLength_type_info = new String[]{'applicationFileLength',SOAP_M_URI,null,'0','1','false'};
        private String[] applicationIconFile_type_info = new String[]{'applicationIconFile',SOAP_M_URI,null,'0','1','false'};
        private String[] applicationIconFileName_type_info = new String[]{'applicationIconFileName',SOAP_M_URI,null,'0','1','false'};
        private String[] applicationInstallUrl_type_info = new String[]{'applicationInstallUrl',SOAP_M_URI,null,'0','1','false'};
        private String[] devicePlatform_type_info = new String[]{'devicePlatform',SOAP_M_URI,null,'1','1','false'};
        private String[] deviceType_type_info = new String[]{'deviceType',SOAP_M_URI,null,'0','1','false'};
        private String[] minimumOsVersion_type_info = new String[]{'minimumOsVersion',SOAP_M_URI,null,'0','1','false'};
        private String[] privateApp_type_info = new String[]{'privateApp',SOAP_M_URI,null,'0','1','false'};
        private String[] version_type_info = new String[]{'version',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'applicationBinaryFile','applicationBinaryFileName','applicationBundleIdentifier','applicationFileLength','applicationIconFile','applicationIconFileName','applicationInstallUrl','devicePlatform','deviceType','minimumOsVersion','privateApp','version'};
    }

    public class ConnectedApp extends Metadata {
        public String type = 'ConnectedApp';
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName',SOAP_M_URI,null,'0','1','false'};
        public MetadataService.ConnectedAppAttribute[] attributes;
        public MetadataService.ConnectedAppCanvasConfig canvasConfig;
        public String contactEmail;
        public String contactPhone;
        public String description;
        public String iconUrl;
        public String infoUrl;
        public MetadataService.ConnectedAppIpRange[] ipRanges;
        public String label;
        public String logoUrl;
        public MetadataService.ConnectedAppMobileDetailConfig mobileAppConfig;
        public String mobileStartUrl;
        public MetadataService.ConnectedAppOauthConfig oauthConfig;
        public String plugin;
        public MetadataService.ConnectedAppSamlConfig samlConfig;
        public String startUrl;
        private String[] attributes_type_info = new String[]{'attributes',SOAP_M_URI,null,'0','-1','false'};
        private String[] canvasConfig_type_info = new String[]{'canvasConfig',SOAP_M_URI,null,'0','1','false'};
        private String[] contactEmail_type_info = new String[]{'contactEmail',SOAP_M_URI,null,'1','1','false'};
        private String[] contactPhone_type_info = new String[]{'contactPhone',SOAP_M_URI,null,'0','1','false'};
        private String[] description_type_info = new String[]{'description',SOAP_M_URI,null,'0','1','false'};
        private String[] iconUrl_type_info = new String[]{'iconUrl',SOAP_M_URI,null,'0','1','false'};
        private String[] infoUrl_type_info = new String[]{'infoUrl',SOAP_M_URI,null,'0','1','false'};
        private String[] ipRanges_type_info = new String[]{'ipRanges',SOAP_M_URI,null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label',SOAP_M_URI,null,'1','1','false'};
        private String[] logoUrl_type_info = new String[]{'logoUrl',SOAP_M_URI,null,'0','1','false'};
        private String[] mobileAppConfig_type_info = new String[]{'mobileAppConfig',SOAP_M_URI,null,'0','1','false'};
        private String[] mobileStartUrl_type_info = new String[]{'mobileStartUrl',SOAP_M_URI,null,'0','1','false'};
        private String[] oauthConfig_type_info = new String[]{'oauthConfig',SOAP_M_URI,null,'0','1','false'};
        private String[] plugin_type_info = new String[]{'plugin',SOAP_M_URI,null,'0','1','false'};
        private String[] samlConfig_type_info = new String[]{'samlConfig',SOAP_M_URI,null,'0','1','false'};
        private String[] startUrl_type_info = new String[]{'startUrl',SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] field_order_type_info = new String[]{'fullName', 'attributes','canvasConfig','contactEmail','contactPhone','description','iconUrl','infoUrl','ipRanges','label','logoUrl','mobileAppConfig','mobileStartUrl','oauthConfig','plugin','samlConfig','startUrl'};
    }

    public class ConnectedAppOauthConfig {
        public String callbackUrl;
        public String certificate;
        public String consumerKey;
        public String consumerSecret;
        public String[] scopes;
        public String singleLogoutUrl;
        private String[] callbackUrl_type_info = new String[]{'callbackUrl',SOAP_M_URI,null,'1','1','false'};
        private String[] certificate_type_info = new String[]{'certificate',SOAP_M_URI,null,'0','1','false'};
        private String[] consumerKey_type_info = new String[]{'consumerKey',SOAP_M_URI,null,'0','1','false'};
        private String[] consumerSecret_type_info = new String[]{'consumerSecret',SOAP_M_URI,null,'0','1','false'};
        private String[] scopes_type_info = new String[]{'scopes',SOAP_M_URI,null,'0','-1','false'};
        private String[] singleLogoutUrl_type_info = new String[]{'singleLogoutUrl',SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'callbackUrl','certificate','consumerKey','consumerSecret','scopes','singleLogoutUrl'};
    }

    public class createMetadata_element {
        public MetadataService.Metadata[] metadata;
        private String[] metadata_type_info = new String[]{'metadata',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'metadata'};
    }

    public class createMetadataResponse_element {
        public MetadataService.SaveResult[] result;
        private String[] result_type_info = new String[]{'result',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }

    public class deleteMetadata_element {
        public String type_x;
        public String[] fullNames;
        private String[] type_x_type_info = new String[]{'type',SOAP_M_URI,null,'1','1','false'};
        private String[] fullNames_type_info = new String[]{'fullNames',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'type_x','fullNames'};
    }

    public class deleteMetadataResponse_element {
        public MetadataService.DeleteResult[] result;
        private String[] result_type_info = new String[]{'result',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }

    public class RemoteSiteSetting extends Metadata {
        public String type = 'RemoteSiteSetting';
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName',SOAP_M_URI,null,'0','1','false'};
        public String description;
        public Boolean disableProtocolSecurity;
        public Boolean isActive;
        public String url;
        private String[] description_type_info = new String[]{'description',SOAP_M_URI,null,'0','1','false'};
        private String[] disableProtocolSecurity_type_info = new String[]{'disableProtocolSecurity',SOAP_M_URI,null,'1','1','false'};
        private String[] isActive_type_info = new String[]{'isActive',SOAP_M_URI,null,'1','1','false'};
        private String[] url_type_info = new String[]{'url',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] field_order_type_info = new String[]{'fullName', 'description','disableProtocolSecurity','isActive','url'};
    }

    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }

    public class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }

    public class DebuggingHeader_element {
        public MetadataService.LogInfo[] categories;
        public String debugLevel;
        private String[] categories_type_info = new String[]{'categories',SOAP_M_URI,null,'0','-1','false'};
        private String[] debugLevel_type_info = new String[]{'debugLevel',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'categories','debugLevel'};
    }

    public class CallOptions_element {
        public String client;
        private String[] client_type_info = new String[]{'client',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'client'};
    }

    public class AllOrNoneHeader_element {
        public Boolean allOrNone;
        private String[] allOrNone_type_info = new String[]{'allOrNone',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'allOrNone'};
    }

    public class ExtendedErrorDetails {
        public String extendedErrorCode;
        private String[] extendedErrorCode_type_info = new String[]{'extendedErrorCode',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'extendedErrorCode'};
    }

    public class LogInfo {
        public String category;
        public String level;
        private String[] category_type_info = new String[]{'category',SOAP_M_URI,null,'1','1','false'};
        private String[] level_type_info = new String[]{'level',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'category','level'};
    }

    public class MetadataPort {
        public String endpoint_x = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/m/42.0';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public MetadataService.SessionHeader_element SessionHeader;
        public MetadataService.DebuggingInfo_element DebuggingInfo;
        public MetadataService.DebuggingHeader_element DebuggingHeader;
        public MetadataService.CallOptions_element CallOptions;
        public MetadataService.AllOrNoneHeader_element AllOrNoneHeader;
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/2006/04/metadata';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/2006/04/metadata';
        private String AllOrNoneHeader_hns = 'AllOrNoneHeader=http://soap.sforce.com/2006/04/metadata';
        private String[] ns_map_type_info = new String[]{SOAP_M_URI, 'MetadataService'};

        public MetadataService.DeleteResult[] deleteMetadata(String type_x,String[] fullNames) {
            MetadataService.deleteMetadata_element request_x = new MetadataService.deleteMetadata_element();
            request_x.type_x = type_x;
            request_x.fullNames = fullNames;
            MetadataService.deleteMetadataResponse_element response_x;
            Map<String, MetadataService.deleteMetadataResponse_element> response_map_x = new Map<String, MetadataService.deleteMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              SOAP_M_URI,
              'deleteMetadata',
              SOAP_M_URI,
              'deleteMetadataResponse',
              'MetadataService.deleteMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }

        public MetadataService.SaveResult[] createMetadata(MetadataService.Metadata[] metadata) {
            MetadataService.createMetadata_element request_x = new MetadataService.createMetadata_element();
            request_x.metadata = metadata;
            MetadataService.createMetadataResponse_element response_x;
            Map<String, MetadataService.createMetadataResponse_element> response_map_x = new Map<String, MetadataService.createMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              SOAP_M_URI,
              'createMetadata',
              SOAP_M_URI,
              'createMetadataResponse',
              'MetadataService.createMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }	
}