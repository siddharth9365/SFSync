global class UpdateFinishExternalFieldIdBatch implements Database.Batchable<Sobject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT ID,PFNCODE__c FROM Finish__c WHERE External_Field_Id__c = null');
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     List<Finish__c> finishList = new List<Finish__c>();
     for(sobject sobj : scope){
     	Finish__c finish = (Finish__c)sobj;
        finish.External_Field_Id__c = 'PRSFINFL'+finish.PFNCODE__c;
        finishList.add(finish); 
     }
     update finishList;
    }

   global void finish(Database.BatchableContext BC){
   }
}