trigger TransactionItemsTrigger on TransactionItem__c (after insert) {
    TransactionItemsHandler handler = new TransactionItemsHandler();
    if(Trigger.IsInsert && Trigger.IsAfter) {
        try{ 
            handler.onAfterInsert(Trigger.newMap);
        }
        catch(Exception exp) {
            Trigger.new[0].addError(exp.getMessage());
            ExceptionHandler.logException('TransactionItemsTrigger.onAfterInsert',JSON.serialize(Trigger.new), exp.getMessage() + exp.getStackTraceString() + exp.getLineNumber());
        }
    }
}