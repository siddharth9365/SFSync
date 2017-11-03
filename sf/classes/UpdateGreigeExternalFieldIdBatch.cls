global class UpdateGreigeExternalFieldIdBatch implements Database.Batchable<Sobject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT ID,PGRFAB__c FROM Greige__c WHERE External_Field_Id__c = null');
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     List<Greige__c> greigeList = new List<Greige__c>();
     for(sobject sobj : scope){
     	Greige__c greige = (Greige__c)sobj;
        greige.External_Field_Id__c = 'PRSGRGFL'+Integer.valueOf(greige.PGRFAB__c);
        greigeList.add(greige); 
     }
     update greigeList;
    }

   global void finish(Database.BatchableContext BC){
   }

}