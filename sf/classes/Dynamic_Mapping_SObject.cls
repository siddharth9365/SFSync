public class Dynamic_Mapping_SObject {
    Map<String,Schema.SObjectType> allObjectsMap;
    List<Product2> productObjectsList = new List<Product2>();
    List<Greige__c> greigeList = new List<Greige__c>();
    List<Performance_Certification__c> performanceCertificationList = new List<Performance_Certification__c>();
    List<Finish__c> finishList = new List<Finish__c>();
    
    String sfObjectName;
    
    //for initializing sobject table name
    public Dynamic_Mapping_SObject(String sfObjectName){
        this.sfObjectName = sfObjectName;
    }
    
    //For adding sobject in list for DML operation
    public void addSfObject(SObject sfObjectData){
        if(this.sfObjectName == 'Product2'){
            Product2 p = (Product2)sfObjectData;
            if(p.PCLSKUID__c!=null){
                p.Name = p.PCLCLR__c;
            }
            productObjectsList.add((Product2)sfObjectData);
        }else if(this.sfObjectName == 'Greige__c'){
            greigeList.add((Greige__c)sfObjectData);
        }else if(this.sfObjectName == 'Performance_Certification__c'){
            performanceCertificationList.add((Performance_Certification__c)sfObjectData);
        }else if(this.sfObjectName == 'Finish__c'){
            finishList.add((Finish__c)sfObjectData);
        }
    }
    
    //For getting status messages of database
    public List<Map<String,String>> getDMLStatusMessages(Database.UpsertResult [] cr){
        Map<String,String> successMap; 
        List<Map<String,String>> successList=new List<Map<String,String>>();
        Set<Id> setSuccessIds = new Set<Id>();
        
        for(Database.UpsertResult p : cr){
            successMap = new Map<String,String>();
            if(p.isSuccess()){
               // successMap.put('Status', 'success');
               // successMap.put('SfId', p.getId());
               // setSuccessIds.add(p.getId());
            }else{
                for(Database.Error er : p.getErrors()){
                    successMap.put('Error ', er.getMessage());
                }
                successMap.put('Status', 'Fail');
                successList.add(successMap);
            }
            
        }
        /*
        String sql = 'select Id,External_Field_Id__c from '+sfObjectName+' where id in :setSuccessIds';
        List<SObject> lst = Database.query(sql);
        Map<String,String> mapsftoext = new Map<String,String>();
        
        for(SObject so : lst)  {
            String sfId = (String)so.get('Id');
            String sfext = (String)so.get('External_Field_Id__c');
            mapsftoext.put(sfId,sfext);
        }
        
        for(Map<String,String> successMap1 : successList)  {
            if(successMap1.get('Status') != null && successMap1.get('Status') == 'success' )  {
                successMap1.put('extId',mapsftoext.get(successMap1.get('SfId')));
            }
        }
*/        
        return successList;
    }
    
    //For userting dynamic sobject via dynamic casting
    public List<Map<String,String>> upsertSobjects(){
        List<Map<String,String>> successList;
        if(this.sfObjectName.equalsIgnoreCase('Product2')){
            Schema.SObjectField f = Product2.Fields.External_Field_Id__c;
            Database.UpsertResult [] cr = Database.upsert(productObjectsList, f, false);
            List<String> productIds = new List<String>();
            for(Product2 p : productObjectsList){

                if(p.Pattern_Lookup__r!=null){

                    productIds.add(p.Pattern_Lookup__r.External_Field_Id__c);
                }
                
            }
            
            List<Product2> finalProductList=[SELECT External_Field_Id__c,name from product2 where External_Field_Id__c in :productIds];
            System.debug('product list size '+finalProductList.size());
            IF(finalProductList.size()>0){
                Map<String,String> productMap =new Map<String,String>();
                for(Product2 p : finalProductList){
                    productMap.put(p.External_Field_Id__c, p.Name);
                }
                
                for(Product2 p : productObjectsList){
                    p.Name = productMap.get(p.Pattern_Lookup__r.External_Field_Id__c)!=null?productMap.get(p.Pattern_Lookup__r.External_Field_Id__c)+'-'+p.PCLCLR__c:p.PCLCLR__c;
                }
            }
            
            Database.upsert(productObjectsList, f, false);
            successList=getDMLStatusMessages(cr);
        }else if(this.sfObjectName.equalsIgnoreCase('Greige__c')){
            Schema.SObjectField f = Greige__c.Fields.External_Field_Id__c;
            Database.UpsertResult [] cr = Database.upsert(greigeList, f, false);
            successList=getDMLStatusMessages(cr);
        }else if(this.sfObjectName.equalsIgnoreCase('Performance_Certification__c')){
            Schema.SObjectField f = Performance_Certification__c.Fields.External_Field_Id__c;
            Database.UpsertResult [] cr = Database.upsert(performanceCertificationList, f, false);
            successList=getDMLStatusMessages(cr);    
        }else if(this.sfObjectName.equalsIgnoreCase('Finish__c')){
            Schema.SObjectField f = Finish__c.Fields.External_Field_Id__c;
            Database.UpsertResult [] cr = Database.upsert(finishList, f, false);
            successList=getDMLStatusMessages(cr);
        }else {
            System.debug('No table info found');
            //Thorw some exception........
        }    
        return successlist;
    }
}