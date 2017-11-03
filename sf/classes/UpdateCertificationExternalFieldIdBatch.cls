global class UpdateCertificationExternalFieldIdBatch implements Database.Batchable<Sobject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT ID,PCETSCD__c FROM Performance_Certification__c WHERE External_Field_Id__c = null');
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     List<Performance_Certification__c> performanceCertiList = new List<Performance_Certification__c>();
     for(sobject sobj : scope){
     	Performance_Certification__c performanceCerti = (Performance_Certification__c)sobj;
        performanceCerti.External_Field_Id__c = 'PRSCERTFL'+performanceCerti.PCETSCD__c;
        performanceCertiList.add(performanceCerti); 
     }
     update performanceCertiList;
    }

   global void finish(Database.BatchableContext BC){
   }
}