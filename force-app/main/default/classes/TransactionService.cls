/*This is a delegate class for managing Transaction and Transaction Item related operations. */
public with sharing class TransactionService {
    public TransactionService() {

    }
   
    /*this is a wrapper structure for Transaction data to be sent in API request. */
    public class TransactionWrapper {
        Map <String,Object> txNode;
        public TransactionWrapper(Transaction__c tx){
            Map<String,String> txData = new Map<String, String> {
                                            'TotalCost' => ((Decimal)tx.Total_Cost__c).toPlainString(),
                                            'TotalDiscount' => ((Decimal)tx.Total_Discount__c).toPlainString(),
                                            'TransactionDate' => tx.LastModifiedDate.format('yyyy-mm-dd','Australia/Sydney'),
                                            'TotalCount' => String.valueOf(tx.Transaction_Count__c)
                                        };
            Map<String,String> txKey = new Map<String,String> { 'TransactionID' => tx.Id };
            txNode = new Map<String,Object> {
                                            'keys' => txKey, 
                                            'values' => txData 
                                        };
        }
    }

    /*this is a wrapper structure for Transaction Item data to be sent in API request. */
    public class TransactionItemWrapper {
        Map <String,Object> tItemNode;
        public TransactionItemWrapper(TransactionItem__c trItem) {
            Map<String,String> triData = new Map<String, String> {
                                            'ItemCost' => ((Decimal)trItem.Item_Cost__c).toPlainString(),
                                            'ItemName' => trItem.Name
                                        };
            Map<String,String> triKey = new Map<String,String> { 'TransactionItemID' => trItem.Id };
            tItemNode = new Map<String,Object> {
                                            'keys' => triKey, 
                                            'values' => triData 
                                        };
        }
    }

    /*
    This method makes the first and second test API calls.
    @param: txIdSet - list of Transaction Ids which has the right number of Transaction items.
    @return: NA
    */
    @future (callout = true) 
    public static void makeTransactionAPICallout (Set<Id> txIdSet) {
        List<TransactionWrapper> txwList = new List<TransactionWrapper>();
        List<TransactionItemWrapper> tItemwList = new List<TransactionItemWrapper>();
        try {
            for(Transaction__c tx:[SELECT Id, Total_Cost__c, Total_Discount__c, Transaction_Count__c, LastModifiedDate,
                        (SELECT Id, Name, Item_Cost__c, Transaction__c FROM TransactionItem__r) FROM Transaction__c 
                        WHERE Id IN :txIdSet LIMIT 10000]) {
                txwList.add(new TransactionWrapper(tx));
                for(TransactionItem__c tItem: tx.TransactionItem__r) {
                    tItemwList.add(new TransactionItemWrapper(tItem));
                }
            }
            HTTPResponse resp1 = SYS_HTTPService.makeHTTPCallout('POST','callout:TransactionService/items',
                            new Map<String,String>{'Content-Type' => 'application/json;charset=UTF-8'},
                            JSON.serialize(tItemwList));
            if(resp1.getStatusCode() == 200) {
                HTTPResponse resp2 = SYS_HTTPService.makeHTTPCallout('POST','callout:TransactionService/detail',
                            new Map<String,String>{'Content-Type' => 'application/json;charset=UTF-8'},
                            JSON.serialize(txwList));
                if(resp2.getStatusCode() != 200) {
                    ExceptionHandler.logException('TransactionService.makeTransactionAPICallout.resp2', JSON.serialize(txIdSet), resp2.toString());
                }
            }
            else {
                ExceptionHandler.logException('TransactionService.makeTransactionAPICallout.resp1', JSON.serialize(txIdSet), resp1.toString());
            }
        }
        catch(Exception exp) {
            ExceptionHandler.logException('TransactionService.makeTransactionAPICallout',JSON.serialize(txIdSet), exp.getMessage() + exp.getStackTraceString() + exp.getLineNumber());
        }
        
    }
}