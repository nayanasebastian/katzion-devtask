/*This is the test class for TransactionItemsHandler class. */
@isTest
private class TransactionItemsHandlerTest {

    /*test the scenario where two API calls are made when the Transaction Items reaches the count at the parent Transaction level.*/
   @isTest
   static void testBothRequestsPass() {
        Transaction__c tx = TestDataUtility.createTransaction('TEST-TX001',100,20,5);
        insert tx;
        List<TransactionItem__c> txItemList = TestDataUtility.createTransactionItems('TI001',10,tx.Id,4);
        insert txItemList;
        TransactionCalloutHTTPMock thisMock = new TransactionCalloutHTTPMock(true, true);
        Test.setMock(HTTPCalloutMock.class, thisMock);
        Test.startTest();
            insert new TransactionItem__c (Name = 'TI001005', Transaction__c = tx.Id, Item_Cost__c = 10);
        Test.stopTest();
        List<Exception_Log__c> expList = new List<Exception_Log__c>([SELECT Id FROM Exception_Log__c LIMIT 1000]);
        System.assert(expList.isEmpty());
   }

   /*This is a bulk test of the trigger operation.*/
   @isTest
   static void bulkTesting() {
        TransactionCalloutHTTPMock thisMock = new TransactionCalloutHTTPMock(true, true);
        Test.setMock(HTTPCalloutMock.class, thisMock);
        List<Transaction__c> txList = new List<Transaction__c>();
        List<TransactionItem__c> txItemList = new List<TransactionItem__c>();
        List<TransactionItem__c> newTxItemList = new List<TransactionItem__c>();
        Integer i;
        for(i=0; i<100 ; i++) {
            txList.add(TestDataUtility.createTransaction('TX'+i,100,20,5));
        }
        insert txList;
        for(Transaction__c tx: txList) {
            for(i=0;i<4; i++){
                txItemList.addAll(TestDataUtility.createTransactionItems(tx.Name+(i+1),10,tx.Id,4));
            }
        }
        insert txItemList;
        for(Transaction__c tx: txList) {
                newTxItemList.add( new TransactionItem__c (Name = tx.Name+(i+1), Transaction__c = tx.Id, Item_Cost__c = 10));
        }
        Test.startTest();
            insert newTxItemList;
        Test.stopTest();
        List<Exception_Log__c> expList = new List<Exception_Log__c>([SELECT Id FROM Exception_Log__c LIMIT 1000]);
        System.assert(expList.isEmpty());
       
   }
}