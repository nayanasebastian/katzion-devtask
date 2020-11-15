/*This is the test class for ExceptionHandler class. */
@isTest
private class ExceptionHandlerTest {
    
    /* test creation of Exception log record */
    @isTest
    static void testExceptionLogging() {
        Test.startTest();
            ExceptionHandler.logException('TestEntity','TestParameters','Sample description');
        Test.stopTest();
        List<Exception_Log__c> expList = new List<Exception_Log__c>([SELECT Id,Description__c,Context__c,Entity__c FROM Exception_Log__c LIMIT 1000]);
        System.assert(('TestEntity').equals(explist[0].Entity__c));
    }
}