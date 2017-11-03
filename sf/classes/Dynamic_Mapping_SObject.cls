public class Dynamic_Mapping_SObject {
    Map<String,Schema.SObjectType> allObjectsMap;
    List<Product2> productObjectsList = new List<Product2>();
    List<Greige__c> greigeList = new List<Greige__c>();
    List<Performance_Certification__c> performanceCertificationList = new List<Performance_Certification__c>();
    List<User> userList = new List<User>();
    List<Account> accountList = new List<Account>();
    List<Brand_Program__c> brandProgramList = new List<Brand_Program__c>();
    
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
        }else if(this.sfObjectName == 'User'){
            userList.add((User)sfObjectData);
        }else if(this.sfObjectName == 'Account'){
            accountList.add((Account)sfObjectData);
        }else if(this.sfObjectName == 'Brand_Program__c'){
            brandProgramList.add((Brand_Program__c)sfObjectData);
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
                successMap.put('External Id :',p.getId() );
                successMap.put('Status', 'Fail');
                successList.add(successMap);
            }
            
        }
        
        return successList;
    }
    
    //For userting dynamic sobject via dynamic casting
    public List<Map<String,String>> upsertSobjects(){
        List<Map<String,String>> successList;
        if(this.sfObjectName.equalsIgnoreCase('Product2')){
            Schema.SObjectField f = Product2.Fields.External_Field_Id__c;
            Database.UpsertResult [] cr;
            String recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Finish' limit 1].Id;    
            if(productObjectsList.size() > 0 && productObjectsList.get(0).RecordTypeId != recordTypeId){
                cr = Database.upsert(productObjectsList, f, false);
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
            }else{
                List<String> externalIds = new List<String>();
                
                for(Product2 p : productObjectsList){
                    externalIds.add(p.External_Field_Id__c);
                }
                
                //insert productObjectsList;
                cr = Database.upsert(productObjectsList, f, false);
                Map<String,Id> externalToIdMap = new Map<String,Id>(); 
                for(Product2 tempProduct : productObjectsList){
                    externalToIdMap.put(tempProduct.External_Field_Id__c, tempProduct.Id);
                }
                //System.debug('size of list : '+externalToIdMap);
                
                List<PricebookEntry> priceBookEntryList = [SELECT Id FROM PricebookEntry where Pricebook2.IsStandard = true and product2.external_field_id__c IN :externalIds];
                Id priceBookId = [SELECT Id FROM Pricebook2 where isStandard = true].id;
                Map<String,PricebookEntry> priceBookMap = new Map<String,PricebookEntry>();
                for(PricebookEntry priceBookEntry : priceBookEntryList){
                    priceBookMap.put(priceBookEntry.Product2.external_field_id__c, priceBookEntry);
                }
                List<PricebookEntry> finalPriceBookEntry = new List<PricebookEntry>();
                for(Product2 p : productObjectsList){
                    PricebookEntry tempPriceBook = priceBookMap.get(p.External_Field_Id__c);
                    if(tempPriceBook != null){
                        tempPriceBook.UnitPrice = p.PFNPRIC_T__c;
                        finalPriceBookEntry.add(tempPriceBook);
                    }else{
                        tempPriceBook = new PricebookEntry();
                        tempPriceBook.Pricebook2Id = priceBookId;
                        tempPriceBook.Product2Id = externalToIdMap.get(p.External_Field_Id__c);
                        tempPriceBook.UnitPrice = p.PFNPRIC_T__c;
                        tempPriceBook.IsActive = true;
                        finalPriceBookEntry.add(tempPriceBook);
                    }
                }
                upsert finalPriceBookEntry;
                successList=getDMLStatusMessages(cr);
            }
        }else if(this.sfObjectName.equalsIgnoreCase('Greige__c')){
            Schema.SObjectField f = Greige__c.Fields.External_Field_Id__c;
            Database.UpsertResult [] cr = Database.upsert(greigeList, f, false);
            successList=getDMLStatusMessages(cr);
        }else if(this.sfObjectName.equalsIgnoreCase('Performance_Certification__c')){
            Schema.SObjectField f = Performance_Certification__c.Fields.External_Field_Id__c;
            Database.UpsertResult [] cr = Database.upsert(performanceCertificationList, f, false);
            successList=getDMLStatusMessages(cr);    
        }else if(this.sfObjectName.equalsIgnoreCase('User')){
            Schema.SObjectField f = User.Fields.External_Field_Id__c;
            Database.UpsertResult [] cr = Database.upsert(userList, f, false);
            successList=getDMLStatusMessages(cr);
        }else if(this.sfObjectName.equalsIgnoreCase('Brand_Program__c')){
            Schema.SObjectField f = Brand_Program__c.Fields.External_Field_Id__c;
            Database.UpsertResult [] cr = Database.upsert(brandProgramList, f, false);
            successList=getDMLStatusMessages(cr);
        }else if(this.sfObjectName.equalsIgnoreCase('Account')){
            Schema.SObjectField f = Account.Fields.External_Field_Id__c;
            //Database.UpsertResult [] cr = Database.upsert(accountList, f, false);
            Set<String> user1Ids = new Set<String>();
            //List<String> user2Ids = new List<String>();
            for(Account tempAccount : accountList){
                System.debug('user1Ids' + tempAccount.Owner.External_Field_Id__c);
                if(tempAccount.Owner != null){
                    user1Ids.add(tempAccount.Owner.External_Field_Id__c);
                }
                if(tempAccount.PCSSLS2__r != null){
                    //tempAccount.PCSSLS2__c = null;
                    user1Ids.add(tempAccount.PCSSLS2__r.External_Field_Id__c);
                }
            }
            List<User> userList = [SELECT External_Field_Id__c,Id FROM USER WHERE External_Field_Id__c IN :user1Ids];
            //List<User> user2List = [SELECT External_Field_Id__c,Id FROM USER WHERE External_Field_Id__c IN :user2Ids];
            Map<String,String> userMap = new Map<String,String>();
            for(User user1 : userList){
                userMap.put(user1.External_Field_Id__c, user1.Id);
            }
            
            for(Account accountTemp : accountList){
                System.debug('owner id' + accountTemp.OwnerId);
                accountTemp.OwnerId = userMap.get(accountTemp.Owner.External_Field_Id__c)!= null?userMap.get(accountTemp.Owner.External_Field_Id__c):UserInfo.getUserId();
               	accountTemp.Owner = null;
                
                accountTemp.PCSSLS2__c = userMap.get(accountTemp.PCSSLS2__r.External_Field_Id__c)!= null?userMap.get(accountTemp.PCSSLS2__r.External_Field_Id__c):null;
                accountTemp.PCSSLS2__r = null;
            }
            Database.UpsertResult [] cr = Database.upsert(accountList, f, false);
            successList=getDMLStatusMessages(cr);
        }else {
            System.debug('No table info found');
            //Thorw some exception........
        }    
        return successlist;
    }
}