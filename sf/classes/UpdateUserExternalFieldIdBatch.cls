global class UpdateUserExternalFieldIdBatch implements Database.Batchable<Sobject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT ID,EmployeeNumber FROM User WHERE External_Field_Id__c = null');
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     List<User> userList = new List<User>();
     for(sobject sobj : scope){
     	User user = (User)sobj;
        user.External_Field_Id__c = 'PRSSLSFL'+user.EmployeeNumber;
        userList.add(user); 
     }
     update userList;
    }

   global void finish(Database.BatchableContext BC){
   }
}