// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Stub__c> stubList = new List<Stub__c>();
stubList.add(new Stub__c ( 
                    Name='TransactionItems',
                    Status_Code__c = 200,
                    Body__c = '{"example":"test"}',
                    URL_Suffix__c = '/stub/transactions/items'       
                            ));
stubList.add(new Stub__c ( 
                    Name='Transaction',
                    Status_Code__c = 200,
                    Body__c = '{"example":"test"}',
                    URL_Suffix__c = '/stub/transactions/detail'       
                            ));
insert stubList;

