/*This is a web-service class to retrieve and send the configured stub response from Stub object record. 
This is useful to test API calls without actual endpoints. */
@RestResource ( urlMapping = '/stub/*')
global with sharing class StubRestResource {

    /*This method retrieves the Stub record, if any, for a request sent to stub URI endpoint. 
    The status code and body of the response is set from the stub record. 
    If there is no configured response, a 404 response is sent back.*/
    @HttpPost
    global static void stubPostResponse() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String uri = EncodingUtil.urlDecode(req.requestURI,'UTF-8');
        List<Stub__c> stub = new List<Stub__c>([SELECT Id, Body__c, Status_Code__c 
                            FROM Stub__c  WHERE URL_suffix__c = :uri LIMIT 1]);
        if(stub.isEmpty()) {
            res.statusCode = 404;
        }
        else {
            res.statusCode = (Integer)stub[0].Status_Code__c;
            res.responseBody = String.isNotBlank(stub[0].Body__c)?Blob.valueOf(stub[0].Body__c):null;
            res.addHeader ('Content-Type','application/json' );
        }
    }
}