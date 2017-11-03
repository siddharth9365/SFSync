global class UpdateAccountExternalFieldIdBatch implements Database.Batchable<Sobject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT ID,PCSCUST__c,PHTCODE__c,PBRBRN__c FROM Account WHERE External_Field_Id__c = null');
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     List<Account> accountList = new List<Account>();
     for(sobject sobj : scope){
     	Account account = (Account)sobj;
        if(account.PHTCODE__c != null){
           account.External_Field_Id__c = 'PRSHOTEL'+account.PHTCODE__c;  
        }else if(account.PBRBRN__c != null){
           account.External_Field_Id__c = 'PRSBRAND'+account.PBRBRN__c; 
        }else if(account.PCSCUST__c != null){
           account.External_Field_Id__c = 'PRSCUSTFL'+account.PCSCUST__c; 
        }
        accountList.add(account); 
     }
     update accountList;
    }

   global void finish(Database.BatchableContext BC){
   }
}