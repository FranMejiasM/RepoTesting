/**
* @description Class where we Execute the Scan
*/
global with sharing class globalCallsToQC {
    global globalCallsToQC() {
        
    } 
    
    /**
* @description Deprecated method whitout the Manual variable
*/
    global boolean execute_scann(Instance__c instance, String gitBranch){
        return null;
    } 
    
    /**
* @description New Execute Scan method whit the Manual variable
*/
    global String execute_scann(Instance__c instance, String gitBranch, Boolean manual){
        
        String result = 'Failure';
        
        List<Scann__c> scanList = [SELECT State__c, Id FROM Scann__c WHERE State__c = 'RUNNING' AND Branch_Name__c =: gitBranch AND Instance__c =: instance.id];
        if(scanList.size() != 0){
            result = 'Delay';
        }else{
            HttpRequest request = RequestCommons();
            QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();
            
            request.setEndpoint(request.getEndpoint() + '/api/'  + settings.API_Version__c + '/feature-branch-scan');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/vnd.api+json');
            request.setHeader('Accept', '*/*');
            
            //If manual is diferent than null send it in the body
            if(manual != null){
                request.setBody('{"data": {"type": "feature-branch-scan","attributes": {"url-id": ' + instance.ID__c + ',"scan-type": 5,"feature-branch": "' + gitBranch + '", "manual": ' + manual + '}}}');
            }else{
                request.setBody('{"data": {"type": "feature-branch-scan","attributes": {"url-id": ' + instance.ID__c + ',"scan-type": 5,"feature-branch": "' + gitBranch + '" }}}');
            }
            
        	HTTPResponse res = ControllerHelperQC.validateAPIKEY(request);
            
            if (res.getStatusCode() == 202){
                jsontoscan.Jsontoscan_c json = jsontoscan.Jsontoscan_c.parse(res.getBody());
                String txt_date = json.data.attributes.scan_date.replace('T', ' ');
                system.debug('txt_date: ' + txt_date);
                Datetime scan_date = ControllerHelperQC.stringToDate(txt_date);
                if (Schema.sObjectType.Scann__c.isCreateable()){
                    insert new Scann__c(Date__c = scan_date, State__c = json.data.attributes.status, ID__c = json.data.id, Scan_Type__c = json.data.type_Z, Branch_Name__c = gitBranch, Instance__c = instance.Id) ;
                    result = 'Success';
                    
                }else {
                    throw new ControllerHelperQC.NoPermissionException('Current user does not have enough permissions to create Scann__c object.');
                }
            }
        }
        return result;
    }
    
    /**
* @description Peer Review Method GET
*/
    global HttpResponse getPeerReview(String feature, String instance) {
        
        HTTPResponse response = new HTTPResponse(); 
        
        HttpRequest request = RequestCommons();
        request.setMethod('GET');
        String encodedFeature = EncodingUtil.urlEncode(feature , 'UTF-8'); 
        request.setEndpoint(request.getEndpoint() + '/peer-review/v1/feature-branch-review/?include=peerReviewElement%2CpeerReviewElement.peerReviewResolution.resolutionStatus&filter=peerReviewElement.instanceId%3D%3D'+instance+'%20and%20featureBranch%3D%3D'+encodedFeature+'&page%5Bsize%5D=1&sort=-id');
        request.setHeader('Accept', '*/*'); 
        
        response = ControllerHelperQC.validateAPIKEY(request);
        
        return response;
    }
    
    /**
* @description Peer Review Method POST
*/
    global HttpResponse createPeerReview(String feature, String instance,String reason, String description) {
        
        HTTPResponse response = new HTTPResponse(); 
        
        HttpRequest request = RequestCommons();
        // Set the POST request method 
        request.setMethod('POST'); 
        request.setEndpoint(request.getEndpoint() + '/peer-review/new-feature-branch-review'); 
        request.setHeader('Content-Type', 'application/json');
        request.setBody('{"data": {"type": "feature-branch-review","attributes": {"feature_branch": "'+ feature +'","instance_id": '+ instance +',"event": "qg_workflow","reason": "'+ reason +'","request_description": "'+ description +'"}}}');         
        
        response = ControllerHelperQC.validateAPIKEY(request);
        
        return response;
    }
    
    /**
* @description Set the common headers for the request
*/
    public HttpRequest RequestCommons() {
        
        QualityCloudsSettings__mdt settings = ControllerHelperQC.getSettings();
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer '+ ControllerHelperQC.getAPIKEY());                
        request.setHeader('client-name', 'GenericHttpClient');
        request.setEndpoint(settings.API_Endpoint__c);
        request.setTimeout(120000);
        
        return request;
    }
    
    /**
* @description Update scan method
*/
    global boolean update_scanns(){        
        return true;
    }
}