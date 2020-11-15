/*This is the test class for TransactionService class. */
@isTest
private class TransactionServiceTest {
    @TestSetup
    static void testData(){
       Transaction__c tx = TestDataUtility.createTransaction('TEST-TX-001',100,20,5);
       insert tx;
       List<TransactionItem__c> txItemList = TestDataUtility.createTransactionItems('TI001',10,tx.Id,4);
       insert txItemList;
    }

    /*Test scenario where both API calls pass.*/
    @isTest
    static void testBothRequestsPass() {
        TransactionCalloutHTTPMock thisMock = new TransactionCalloutHTTPMock(true, true);
        Test.setMock(HTTPCalloutMock.class, thisMock);
        Transaction__c tx = [SELECT Id FROM Transaction__c LIMIT 1];
        Test.startTest();
            insert new TransactionItem__c (Name = 'TEST-TI-005', Transaction__c = tx.Id, Item_Cost__c = 10);
        Test.stopTest();
        List<Exception_Log__c> expList = new List<Exception_Log__c>([SELECT Id FROM Exception_Log__c LIMIT 1000]);
        System.assert(expList.isEmpty());
    }

    /*Test scenario where first call (Transaction Items) passes and second call (Transaction) fails .*/
    @isTest
    static void testSecondRequestFail() {
        TransactionCalloutHTTPMock thisMock = new TransactionCalloutHTTPMock(true, false);
        Test.setMock(HTTPCalloutMock.class, thisMock);
        Transaction__c tx = [SELECT Id FROM Transaction__c LIMIT 1];
        Test.startTest();
            insert new TransactionItem__c (Name = 'TEST-TI-005', Transaction__c = tx.Id, Item_Cost__c = 10);
        Test.stopTest();
        List<Exception_Log__c> expList = new List<Exception_Log__c>([SELECT Id,Description__c,Context__c,Entity__c FROM Exception_Log__c LIMIT 1000]);
        System.assert(explist[0].Entity__c.contains('resp2'));
        System.assert(explist[0].Context__c.contains(tx.Id));
   }

    /*Test scenario where first call (Transaction Items) fails .*/
    @isTest
    static void testFirstRequestFail() {
        TransactionCalloutHTTPMock thisMock = new TransactionCalloutHTTPMock(false, true);
        Test.setMock(HTTPCalloutMock.class, thisMock);
        Transaction__c tx = [SELECT Id FROM Transaction__c LIMIT 1];
        Test.startTest();
            insert new TransactionItem__c (Name = 'TEST-TI-005', Transaction__c = tx.Id, Item_Cost__c = 10);
        Test.stopTest();
        List<Exception_Log__c> expList = new List<Exception_Log__c>([SELECT Id,Description__c,Context__c,Entity__c FROM Exception_Log__c LIMIT 1000]);
        System.assert(explist[0].Entity__c.contains('resp1'));
        System.assert(explist[0].Context__c.contains(tx.Id));
   }
}