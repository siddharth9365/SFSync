@istest
public class Dynamic_Table_MappingServiceTest{
    static String uri = '/services/apexrest/insertAndUpdateProduct';
    static String method = 'POST';
    
    public static testMethod void greig(){
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'PGRFAB';
        dyTbleMap.Db_Table_Name__c = 'PRSGRGFL';
        dyTbleMap.Sf_Field_Name__c = 'PGRFAB__c';
        dyTbleMap.Sf_Table_Name__c = 'Greige__c';
        insert dyTbleMap;
        String json = '{"tableName": "PRSGRGFL","uniqueFieldName": "PGRFAB","tableData": [[{"fieldName": "PGRFAB","fieldValue": "5"}]]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
       // Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('product2'), 'PRSPATFL');
        Dynamic_Table_MappingService.insertAndUpdate();
        //Dynamic_Mapping_SObject upsertDynamicSobject = new Dynamic_Mapping_SObject('product2');
        Test.stopTest();
    }
    
    public static testMethod void performance(){
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'PCETSCD';
        dyTbleMap.Db_Table_Name__c = 'PRSCERTFL';
        dyTbleMap.Sf_Field_Name__c = 'PCETSCD__c';
        dyTbleMap.Sf_Table_Name__c = 'Performance_Certification__c';
        insert dyTbleMap;
        String json = '{"tableName": "PRSCERTFL","uniqueFieldName": "PCETSCD","tableData": [[{"fieldName": "PCETSCD","fieldValue": "5"}]]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
       // Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('product2'), 'PRSPATFL');
        Dynamic_Table_MappingService.insertAndUpdate();
        //Dynamic_Mapping_SObject upsertDynamicSobject = new Dynamic_Mapping_SObject('product2');
        Test.stopTest();
    }
    
    public static testMethod void user(){
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'PSLSLS#';
        dyTbleMap.Db_Table_Name__c = 'PRSSLSFL';
        dyTbleMap.Sf_Field_Name__c = 'PSLSLS__c';
        dyTbleMap.Sf_Table_Name__c = 'User';
        insert dyTbleMap;
        String json = '{"tableName": "PRSSLSFL","uniqueFieldName": "PSLSLS#","tableData": [[{"fieldName": "PSLSLS#","fieldValue": "01"}]]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
       // Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('product2'), 'PRSPATFL');
        Dynamic_Table_MappingService.insertAndUpdate();
        //Dynamic_Mapping_SObject upsertDynamicSobject = new Dynamic_Mapping_SObject('product2');
        Test.stopTest();
    }
    
    public static testMethod void account(){
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'PCSCUST';
        dyTbleMap.Db_Table_Name__c = 'PRSCUSTFL';
        dyTbleMap.Sf_Field_Name__c = 'PCSCUST__c';
        dyTbleMap.Sf_Table_Name__c = 'Account';
        insert dyTbleMap;
        String json = '{"tableName": "PRSCUSTFL","uniqueFieldName": "PCSCUST","tableData": [[{"fieldName": "PCSCUST","fieldValue": "1"}]]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
       // Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('product2'), 'PRSPATFL');
        Dynamic_Table_MappingService.insertAndUpdate();
        //Dynamic_Mapping_SObject upsertDynamicSobject = new Dynamic_Mapping_SObject('product2');
        Test.stopTest();
    }
    
    public static testMethod void finish(){
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'PFNCODE';
        dyTbleMap.Db_Table_Name__c = 'PRSFINFL';
        dyTbleMap.Sf_Field_Name__c = 'PFNCODE__c';
        dyTbleMap.Sf_Table_Name__c = 'Finish__c';
        insert dyTbleMap;
        String json = '{"tableName": "PRSFINFL","uniqueFieldName": "PFNCODE","tableData": [[{"fieldName": "PFNCODE","fieldValue": "5"}]]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
       // Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('product2'), 'PRSPATFL');
        Dynamic_Table_MappingService.insertAndUpdate();
        //Dynamic_Mapping_SObject upsertDynamicSobject = new Dynamic_Mapping_SObject('product2');
        Test.stopTest();
    }
    
    public static testMethod void patternLookup(){
        RecordType rt1 = [select id,Name from RecordType where SobjectType='product2' and DeveloperName = 'Product_Pattern_Woven_Finished_Good' Limit 1];
        product2 acc1 = new product2(Name='Product_Pattern_Woven_Finished_Good' , recordTypeId=rt1.id);
        
        product2 pr1 = new product2();
        pr1.RecordTypeId = rt1.Id;
        pr1.Color_Number__c = 'color2';
        pr1.Description = 'test desc2';
        pr1.Name = 'name2';
        pr1.PPTPATID__c = '1379';
        pr1.External_Field_Id__c = 'PRSPATFL1379';
        insert pr1;
        
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'PCLSKUID';
        dyTbleMap.Db_Table_Name__c = 'PRSCLRFL';
        dyTbleMap.Sf_Field_Name__c = 'PCLSKUID__c';
        dyTbleMap.Sf_Table_Name__c = 'product2';
        insert dyTbleMap;
        
        Dynamic_Table_Mapping__c dyTbleMap1 = new Dynamic_Table_Mapping__c();
        dyTbleMap1.Db_Field_Name__c = 'PCLPATID';
        dyTbleMap1.Db_Table_Name__c = 'PRSCLRFL';
        dyTbleMap1.Sf_Field_Name__c = 'Pattern_Lookup__c';
        dyTbleMap1.Sf_Table_Name__c = 'product2';
        dyTbleMap1.Db_Lookup_Name__c = 'PRSPATFL';
        dyTbleMap1.Sf_Lookup_Name__c = 'product2';
        insert dyTbleMap1;

        String json = '{"tableName": "PRSCLRFL","uniqueFieldName": "PCLSKUID","tableData": [[{"fieldName": "PCLSKUID","fieldValue": "5"},{"fieldName": "PCLPATID","fieldValue": "1379"}]]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
       // Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('product2'), 'PRSPATFL');
        Dynamic_Table_MappingService.insertAndUpdate();
        //Dynamic_Mapping_SObject upsertDynamicSobject = new Dynamic_Mapping_SObject('product2');
        Test.stopTest();
    }
    
    public static testMethod void method2(){
        RecordType rt = [select id,Name from RecordType where SobjectType='product2' and DeveloperName = 'Product_Pattern_Woven_Finished_Good' Limit 1];
        product2 acc = new product2(Name='Product_Pattern_Woven_Finished_Good' , recordTypeId=rt.id);
        
        product2 pr = new product2();
        pr.RecordTypeId = rt.Id;
        pr.Color_Number__c = 'color';
        pr.Description = 'test desc';
        pr.Name = 'name';
        insert pr;
        product2 pr2 = new product2();
        pr2.RecordTypeId = rt.Id;
        pr2.Color_Number__c = 'color2';
        pr2.Description = 'test desc2';
        pr2.Name = 'name2';
        insert pr2;
        
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'PPTWGHT';
        dyTbleMap.Db_Table_Name__c = 'PRSPATFL';
        dyTbleMap.Sf_Field_Name__c = 'PPTWGHT__c';
        dyTbleMap.Sf_Table_Name__c = 'product2';
        insert dyTbleMap;
        
        Dynamic_Table_Mapping__c dyTbleMap1 = new Dynamic_Table_Mapping__c();
        dyTbleMap1.Db_Field_Name__c = 'PPTPAT';
        dyTbleMap1.Db_Table_Name__c = 'PRSPATFL';
        dyTbleMap1.Sf_Field_Name__c = 'PPTPAT__c';
        dyTbleMap1.Sf_Table_Name__c = 'product2';
        insert dyTbleMap1;
        
        Dynamic_Table_Mapping__c dyTbleMap2 = new Dynamic_Table_Mapping__c();
        dyTbleMap2.Db_Field_Name__c = 'PPTSTYR';
        dyTbleMap2.Db_Table_Name__c = 'PRSPATFL';
        dyTbleMap2.Sf_Field_Name__c = 'PPTSTYR__c';
        dyTbleMap2.Sf_Table_Name__c = 'product2';
        insert dyTbleMap2;
        
        Dynamic_Table_Mapping__c dyTbleMap3 = new Dynamic_Table_Mapping__c();
        dyTbleMap3.Db_Field_Name__c = 'PPTDESC';
        dyTbleMap3.Db_Table_Name__c = 'PRSPATFL';
        dyTbleMap3.Sf_Field_Name__c = 'PPTDESC__c';
        dyTbleMap3.Sf_Table_Name__c = 'product2';
        insert dyTbleMap3;

        String json = '{"tableName": "PRSPATFL","uniqueFieldName": "PPTWGHT","tableData": [[{"fieldName": "PPTPAT","fieldValue": "5"},{"fieldName": "PPTSTYR","fieldValue": 5},{"fieldName": "PPTWGHT","fieldValue": "1"},{"fieldName": "PPTDESC","fieldValue": "des"}]]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('product2'), 'PRSPATFL');
        Dynamic_Table_MappingService.insertAndUpdate();
        //Dynamic_Mapping_SObject upsertDynamicSobject = new Dynamic_Mapping_SObject('product2');
        Test.stopTest();
    }
    
    public static testMethod void method6(){
        String json = '{"tabelName": "PRSPATFL","uniqueFieldName": "PPTWGHT","tableData": []}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Map<String,String> responseMap = new Map<String,String>();
        responseMap.put('Status', 'No Failures....');
        Test.startTest();
        Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('product2'), 'PRSPATFL');
        Dynamic_Table_MappingService.insertAndUpdate();
        //Dynamic_Mapping_SObject upsertDynamicSobject = new Dynamic_Mapping_SObject('product2');
        Test.stopTest();
    }
     
    public static testMethod void method4(){   
        
        RecordType rt = [select id,Name from RecordType where SobjectType='product2' and DeveloperName = 'Product_Color' Limit 1];
        product2 acc = new product2(Name='Test' , recordTypeId=rt.id);
        
        product2 pr = new product2();
        pr.RecordTypeId = rt.Id;
        pr.Color_Number__c = 'color';
        pr.Description = 'test desc';
        pr.Name = 'name';
        insert pr;
        
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'test';
        dyTbleMap.Db_Table_Name__c = 'Color';
        dyTbleMap.Sf_Field_Name__c = 'name';
        dyTbleMap.Sf_Table_Name__c = 'AccountId';
        insert dyTbleMap;
        
        
        Test.startTest();
        Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('AccountId'), 'Color');
        Test.stopTest();
    }
    
    public static testMethod void method5(){   
        
        RecordType rt = [select id,Name from RecordType where SobjectType='product2' and DeveloperName = 'Product_Color' Limit 1];
        product2 acc = new product2(Name='Product_Color' , recordTypeId=rt.id);
        
        product2 pr = new product2();
        pr.RecordTypeId = rt.Id;
        pr.Color_Number__c = 'color';
        pr.Description = 'test desc';
        pr.Name = 'name';
        insert pr;
        
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'test';
        dyTbleMap.Db_Table_Name__c = 'Greige';
        dyTbleMap.Sf_Field_Name__c = 'name';
        dyTbleMap.Sf_Table_Name__c = 'AccountId';
        insert dyTbleMap; 
        Test.startTest();
        Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('AccountId'), 'Greige');
        Test.stopTest();
    }
    
    public static testMethod void Brand(){
        Dynamic_Table_Mapping__c dyTbleMap = new Dynamic_Table_Mapping__c();
        dyTbleMap.Db_Field_Name__c = 'PCSCUST';
        dyTbleMap.Db_Table_Name__c = 'PRSCUSTFL';
        dyTbleMap.Sf_Field_Name__c = 'PCSCUST__c';
        dyTbleMap.Sf_Table_Name__c = 'Brand_Program__c';
        insert dyTbleMap;
        String json = '{"tableName": "PRSCUSTFL","uniqueFieldName": "PCSCUST","tableData": [[{"fieldName": "PCSCUST","fieldValue": "1554501"}]]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
       // Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('product2'), 'PRSPATFL');
        Dynamic_Table_MappingService.insertAndUpdate();
        //Dynamic_Mapping_SObject upsertDynamicSobject = new Dynamic_Mapping_SObject('product2');
        Test.stopTest();
    }
    
    public static testmethod void upsertSobjectsTest(){
        RecordType rt = [select id,Name from RecordType where SobjectType='product2' and DeveloperName = 'Finish' Limit 1];
        product2 acc = new product2(Name='Finish' , recordTypeId=rt.id);
        /*
        product2 pr = new product2();
        pr.RecordTypeId = rt.Id;
        pr.Color_Number__c = 'color';
        pr.Description = 'test desc';
        pr.Name = 'name';
        pr.ProductCode = 'test';
        pr.External_Field_Id__c = 'PRSPATFL1379';
        
        lstPro.add(pr);
        
        product2 pr1 = new product2();
        pr1.RecordTypeId = rt.Id;
        pr1.Color_Number__c = 'color2';
        pr1.Description = 'test desc2';
        pr1.Name = 'name2';
        pr1.ProductCode = 'test1';
        pr1.PPTPATID__c = '1379';
        pr1.External_Field_Id__c = 'PRSPATFL1379';
        
        lstPro.add(pr1);
        
        insert lstPro; */
        
        Dynamic_Table_Mapping__c dyTbleMap2 = new Dynamic_Table_Mapping__c();
        dyTbleMap2.Db_Field_Name__c = 'PFNCODE';
        dyTbleMap2.Db_Table_Name__c = 'PRSFINFL';
        dyTbleMap2.Sf_Field_Name__c = 'ProductCode';
        dyTbleMap2.Sf_Table_Name__c = 'product2';
        insert dyTbleMap2;
        
        Dynamic_Table_Mapping__c dyTbleMap3 = new Dynamic_Table_Mapping__c();
        dyTbleMap3.Db_Field_Name__c = 'PFNDESC';
        dyTbleMap3.Db_Table_Name__c = 'PRSFINFL';
        dyTbleMap3.Sf_Field_Name__c = 'Name';
        dyTbleMap3.Sf_Table_Name__c = 'product2';
        insert dyTbleMap3;
        
        String json = '{"tableName": "PRSFINFL","uniqueFieldName": "PFNCODE","tableData": [[{"fieldName": "PFNCODE","fieldValue": "5"},{"fieldName": "PFNDESC","fieldValue": "1379"}]]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI =   uri;
        req.httpMethod = method;
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
       // Dynamic_Table_MappingService.getRecordTypeId(Schema.getGlobalDescribe().get('product2'), 'PRSPATFL');
        Dynamic_Table_MappingService.insertAndUpdate();
        //Dynamic_Mapping_SObject upsertDynamicSobject = new Dynamic_Mapping_SObject('product2');
        Test.stopTest();
        
       /* Pricebook2 pcb = new Pricebook2();
        pcb.IsStandard = true;
        insert pcb;
        
        PricebookEntry pcBkE = new PricebookEntry();
        pcBkE.Pricebook2Id = pcb.Id;
        
        Test.startTest();
        Dynamic_Mapping_SObject.upsertSobjects();
        Test.stopTest();
        */
    }

}