global class UpdateProductExternalFieldIdBatch implements Database.Batchable<Sobject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT ID,ProductCode,PPTPATID__c,PCLSKUID__c,PFNPRIC_T__c,RecordTypeId FROM Product2 WHERE External_Field_Id__c = null');
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Product2> productList = new List<Product2>();
        List<RecordType> recordTypeList = [SELECT id,DeveloperName,Name FROM RecordType];  
        Map<String,String> recordTypeMap = new Map<String,String>();
        for(RecordType recordType : recordTypeList)
            recordTypeMap.put(recordType.Id,recordType.DeveloperName);
        for(sobject sobj : scope){
            Product2 product = (Product2)sobj;
            if(recordTypeMap.get(product.RecordTypeId) == 'Product_Color'){
                product.External_Field_Id__c = 'PRSCLRFL'+product.PCLSKUID__c;     
            }else if(recordTypeMap.get(product.RecordTypeId) == 'Finish'){
                product.External_Field_Id__c = 'PRSFINFL'+product.ProductCode;
            }else if(recordTypeMap.get(product.RecordTypeId) == 'Product_Pattern_Woven_Finished_Good'){
                product.External_Field_Id__c = 'PRSPATFL'+product.PPTPATID__c;
            } 
            
            productList.add(product); 
        }
        update productList;
    }
    
    global void finish(Database.BatchableContext BC){
    }
}