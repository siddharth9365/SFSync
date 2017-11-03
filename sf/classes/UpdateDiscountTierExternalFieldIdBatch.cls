global class UpdateDiscountTierExternalFieldIdBatch implements Database.Batchable<Sobject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT ID,SBQQ__Schedule__c,Name FROM SBQQ__DiscountTier__c WHERE External_Field_Id__c = null');
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     List<SBQQ__DiscountTier__c> discountList = new List<SBQQ__DiscountTier__c>();
     for(sobject sobj : scope){
     	SBQQ__DiscountTier__c discount = (SBQQ__DiscountTier__c)sobj;
        discount.External_Field_Id__c = discount.SBQQ__Schedule__c+discount.Name;
        discountList.add(discount); 
     }
     update discountList;
    }

   global void finish(Database.BatchableContext BC){
   }
}