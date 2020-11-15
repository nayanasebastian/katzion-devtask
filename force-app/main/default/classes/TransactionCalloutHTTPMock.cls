/* This is a mock response class for testing HTTP callouts. */
@isTest
public class TransactionCalloutHTTPMock implements HTTPCalloutMock {
    public Boolean test1Pass = true;
    public Boolean test2Pass = true;
    
    public TransactionCalloutHTTPMock() {}

    public TransactionCalloutHTTPMock(Boolean test1, Boolean test2) {
        test1Pass = test1;
        test2Pass = test2;
    }

    /*This predefined method is invoked at run time for a mock test HTTP call. */
    public HTTPResponse respond (HTTPRequest req) {
        HTTPResponse res = new HTTPResponse ();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        Integer statusCode = 200;
        if(req.getEndpoint().endsWith('items')) {
            statusCode = test1Pass? 200 : 500;
        }
        else if(req.getEndpoint().endsWith('detail')) {
            statusCode = test2Pass? 200 : 500;
        }
        res.setStatusCode(statusCode);
        return res;
    }   
}