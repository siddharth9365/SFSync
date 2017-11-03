global class UpdateBrandProgramExternalFieldIdBatch implements Database.Batchable<Sobject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT ID,PBPBRP__c FROM Brand_Program__c WHERE External_Field_Id__c = null');
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     List<Brand_Program__c> brandProgramList = new List<Brand_Program__c>();
     for(sobject sobj : scope){
     	Brand_Program__c brandProgram = (Brand_Program__c)sobj;
        brandProgram.External_Field_Id__c = 'PRSBRPGM'+brandProgram.PBPBRP__c;
        brandProgramList.add(brandProgram); 
     }
     update brandProgramList;
    }

   global void finish(Database.BatchableContext BC){
   }
}