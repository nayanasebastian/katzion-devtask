/*This is the Trigger handler class for Transaction Items trigger.*/
public with sharing class TransactionItemsHandler {
    TransactionService txService = new TransactionService() ;
    public TransactionItemsHandler() {

    }
    /*method on after insert. This is used to make Transaction API test call 1 and 2 after a Transaction Item record is inserted.
    @param - Trigger.newMap.
    @return - NA
    */
    public void onAfterInsert(Map<Id,TransactionItem__c> updatedTIMap) {
        Set<Id> txIdSet = new Set<Id>();
        Map<Id,Transaction__c> tRelMap = new Map<Id,Transaction__c>();
        for(TransactionItem__c tItem : updatedTIMap.values()) {
            txIdSet.add(tItem.Transaction__c);
        }
        if(!txIdSet.isEmpty()) {
            tRelMap = new Map<Id,Transaction__c> ([SELECT Id, Transaction_Count__c, 
                    (SELECT Id FROM TransactionItem__r) FROM Transaction__c 
                    WHERE Id IN :txIdSet LIMIT 10000]);
            for(Transaction__c tx: tRelMap.values()) {
                if(tx.TransactionItem__r.size() == 0 || tx.Transaction_Count__c != tx.TransactionItem__r.size()) {
                    tRelMap.remove (tx.Id);
                }
            }        
            if(!tRelMap.isEmpty()) {
                TransactionService.makeTransactionAPICallout(tRelMap.keySet());
            }
        }
        
    }

}