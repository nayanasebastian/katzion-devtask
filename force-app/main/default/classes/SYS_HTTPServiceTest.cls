/*This is the test class for SYS_HTTPService class.*/
@isTest
private class SYS_HTTPServiceTest {
    
    /*This method tests the callout action and confirms if the response matches the mock response.*/
    @isTest
    static void testHTTPRequest() {
        HTTPResponse res;
        TransactionCalloutHTTPMock thisMock = new TransactionCalloutHTTPMock(true, true);
        Test.setMock(HTTPCalloutMock.class, thisMock);
        Test.startTest();
            res = SYS_HTTPService.makeHTTPCallout('POST','/testendpoint',
                            new Map<String,String>{'Content-Type' => 'application/json;charset=UTF-8'},
                            '{"example":"test"}');
        Test.stopTest();
        System.assertEquals(res.getStatusCode(), 200);

    }
}