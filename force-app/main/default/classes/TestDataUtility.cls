/*This is a generic data utility class for creating test data for test methods.*/
@isTest
public class TestDataUtility {

    /*
    create a Transaction record instance.
    @param: name - String
    @param: totalCost - the Total Cost $ value for the record.
    @param: totalDiscount - the Total Discount $ value for the record.
    @param: totalCount - the total number of Transaction Items for that Transaction.
    @return: Transaction record instance.
    */
    public static Transaction__c createTransaction(String name, Decimal totalCost, Decimal totalDiscount, Integer totalCount) {
        return new Transaction__c(
                        Name = name,
                        Total_Cost__c = totalCost, 
                        Total_Discount__c = totalDiscount, 
                        Transaction_Count__c = totalCount);
    }
    /*
    create a list of Transaction Item record instances for a given Transaction.
    @param: namePrefix - String
    @param: itemCost - the Item Cost $ value for each record(s).
    @param: parentTransactionId - the ID of the parent Transaction record.
    @param: count - the number of Transaction Items to be created.
    @return: list of Transaction Items.
    */
    public static List<TransactionItem__c> createTransactionItems(String namePrefix, Decimal itemCost, Id parentTransactionId, Integer count) {
        List<TransactionItem__c> txItemList = new List<TransactionItem__c>();
        for(Integer i=0; i<count;i++) {
            txItemList.add(new TransactionItem__c(
                    Name = namePrefix + (i+1),
                    Item_Cost__c = itemCost,
                    Transaction__c = parentTransactionId
            ));
        }
        return txItemList;
    }
    
    /*
    create a Stub response record to be used for testing.
    @param: statusCode - the Status Code for the response at run time.
    @param: body - the response body at run time.
    @param: urlSuffix - the stub URI of the test request.
    @return: a Stub record instance.
    */
    public static Stub__c createStubResponse(Integer statusCode, String body, String urlSuffix) {
        return new Stub__c ( 
                    Name='Test Stub',
                    Status_Code__c = statusCode,
                    Body__c = body,
                    URL_Suffix__c = urlSuffix       
                            );
    }
}