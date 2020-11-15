/*This is the test class for StubRestResource class. */
@isTest
private class StubRestResourceTest {
   
    /*test the stub response behaviour when there is a configured Stub record matching the request.
    The request should be set with data from the Stub record.*/
    @isTest
    static void testPostRequestWithStub() {
        Stub__c testStub = TestDataUtility.createStubResponse(200,'{"example":"test"}','/stub/test');
        insert testStub;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/stub/test';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            StubRestResource.stubPostResponse();
        Test.stopTest();
        System.assertEquals(res.statusCode,200);

    }

    /*test the stub response behaviour when there is no response configured in stub. 
    if the request is still sent to the stub endpoint, it should return a 404 response.*/
    @isTest
    static void testPostRequestWithoutStub() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/stub/test';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            StubRestResource.stubPostResponse();
        Test.stopTest();
        System.assertEquals(res.statusCode,404);

    }
}