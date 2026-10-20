public with sharing class HttpCalloutTimeoutSample {

    // Positive: request declared and sent without setTimeout
    public HttpResponse calloutWithoutTimeout() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Example_API/accounts');
        req.setMethod('GET');
        Http http = new Http();
        return http.send(req);
    }

    // Positive: request assigned (not declared) and sent without setTimeout
    public HttpResponse calloutAssignedWithoutTimeout() {
        HttpRequest req;
        req = new HttpRequest();
        req.setEndpoint('callout:Example_API/contacts');
        req.setMethod('GET');
        return new Http().send(req);
    }

    // Negative: timeout set before sending
    public HttpResponse calloutWithTimeout() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Example_API/accounts');
        req.setMethod('GET');
        req.setTimeout(30000);
        Http http = new Http();
        return http.send(req);
    }

    // Negative: request built but never sent in this method
public with sharing class HttpCalloutTimeoutSample {

    // Positive: request declared and sent without setTimeout
    public HttpResponse calloutWithoutTimeout() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Example_API/accounts');
        req.setMethod('GET');
        Http http = new Http();
        return http.send(req);
    }

    // Positive: request assigned (not declared) and sent without setTimeout
    public HttpResponse calloutAssignedWithoutTimeout() {
        HttpRequest req;
        req = new HttpRequest();
        req.setEndpoint('callout:Example_API/contacts');
        req.setMethod('GET');
        return new Http().send(req);
    }

    // Negative: timeout set before sending
    public HttpResponse calloutWithTimeout() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Example_API/accounts');
        req.setMethod('GET');
        req.setTimeout(30000);
        Http http = new Http();
        return http.send(req);
    }

    // Negative: request built but never sent in this method
    public HttpRequest buildRequestOnly() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Example_API/accounts');
        req.setMethod('GET');
        return req;
    }
}