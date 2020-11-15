/*This utility class creates a record in Exception Log object for any run time errors */
public with sharing class ExceptionHandler {

    /*
    insert an exception log record with the provided details.
    @param: entity - the interface from which exception is thrown.
    @param: parameters - the details of the record(s) from run time.
    @param: description - error or exception information.
    @return: NA
    */
    public static void logException (String entity, String parameters, String description) {
         Exception_Log__c exRec = new Exception_Log__c(
                                    Description__c = description,
                                    Entity__c = entity.left(255),
                                    Context__c = parameters.left(255),
                                    Time_Stamp__c = System.now()
                                    );
        Database.insert(exRec,false);
    }
}