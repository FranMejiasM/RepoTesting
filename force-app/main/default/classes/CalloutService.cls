public with sharing class CalloutService {
    private HttpRequest fieldReq;

    public void noTimeout() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Api');
        req.setMethod('GET');
        HttpResponse res = new Http().send(req);
    }

    public void noTimeoutHttpVar() {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        h.send(req);
    }

    public void timeoutOnOtherRequest() {
        HttpRequest a = new HttpRequest();
        HttpRequest b = new HttpRequest();
        a.setTimeout(20000);
        new Http().send(a);
        new Http().send(b);
    }

    public void assignedLater() {
        HttpRequest req;
        req = new HttpRequest();
        new Http().send(req);
    }

    public void withTimeout() {
        HttpRequest req = new HttpRequest();
        req.setTimeout(30000);
        new Http().send(req);
    }

    public void withTimeoutUpperCase() {
        HttpRequest req = new HttpRequest();
        req.SETTIMEOUT(30000);
        new Http().send(req);
    }

    public void notSent() {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
    }

    public void builtElsewhere() {
        new Http().send(buildRequest());
    }

    public HttpRequest buildRequest() {
        HttpRequest req = new HttpRequest();
        req.setTimeout(10000);
        return req;
    }
}