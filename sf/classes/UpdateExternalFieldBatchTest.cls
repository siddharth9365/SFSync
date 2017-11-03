@isTest
public class UpdateExternalFieldBatchTest {
	public static testMethod void greig(){
		List<Greige__c> greigeList= new List<Greige__c>();
        for(Integer i=0 ;i <100;i++){
            Greige__c greige = new Greige__c();
            greige.Name ='Name'+i;
            greige.PGRFAB__c = i;
            greigeList.add(greige);
        }
        insert greigeList;
        Test.startTest();
            UpdateGreigeExternalFieldIdBatch obj = new UpdateGreigeExternalFieldIdBatch();
            DataBase.executeBatch(obj); 
        Test.stopTest();        
    }
    
    public static testMethod void brandProgram(){
		List<Brand_Program__c> brandProgramList = new List<Brand_Program__c>();
		Account acc = new account();
        acc.Name ='Name';
        acc.PBRBRN__c = 'test';
        insert acc;

        for(Integer i=0 ;i <30;i++){
            Brand_Program__c brandProgram = new Brand_Program__c();
            brandProgram.PBPBRP__c ='Name'+i;
            brandProgramList.add(brandProgram);
            brandProgram.PGMBRM__c = acc.id;
        }
        insert brandProgramList;
        Test.startTest();
            UpdateBrandProgramExternalFieldIdBatch obj = new UpdateBrandProgramExternalFieldIdBatch();
            DataBase.executeBatch(obj); 
        Test.stopTest();        
    } 
    
    public static testMethod void performanceCertification(){
		List<Performance_Certification__c> certificateList= new List<Performance_Certification__c>();
        for(Integer i=0 ;i <100;i++){
            Performance_Certification__c certificate = new Performance_Certification__c();
            certificate.PCETSCD__c ='Name'+i;
            certificateList.add(certificate);
        }
        insert certificateList;
        Test.startTest();
            UpdateCertificationExternalFieldIdBatch obj = new UpdateCertificationExternalFieldIdBatch();
            DataBase.executeBatch(obj); 
        Test.stopTest();        
    }
    
    public static testMethod void dicountTier(){
        SBQQ__DiscountSchedule__c discountSchedule = new SBQQ__DiscountSchedule__c();
        discountSchedule.Name = 'test';
        insert discountSchedule;
		List<SBQQ__DiscountTier__c> discountList= new List<SBQQ__DiscountTier__c>();
        for(Integer i=0 ;i <100;i++){
            SBQQ__DiscountTier__c discount = new SBQQ__DiscountTier__c();
            discount.Name ='Name'+i;
            discount.SBQQ__Schedule__c = discountSchedule.Id;
            discountList.add(discount);
        }
        insert discountList;
        Test.startTest();
            UpdateDiscountTierExternalFieldIdBatch obj = new UpdateDiscountTierExternalFieldIdBatch();
            DataBase.executeBatch(obj); 
        Test.stopTest();        
    }
    
    public static testMethod void product(){
		List<Product2> productList= new List<Product2>();
        Id pattern = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product Pattern').getRecordTypeId();
        Id finish = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Finish').getRecordTypeId();
        Id color = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product Color').getRecordTypeId();
        for(Integer i=0 ;i <40;i++){
            Product2 product = new Product2();
            if(i<10){
            	product.PCLSKUID__c = 'c' + i;
                product.Name = 'name'+i;
                product.RecordTypeId = color;
            }else if(i<20){
                product.PPTPATID__c = 'p' + i;
                product.Name = 'name'+i;
                product.RecordTypeId = pattern;
            }else if(i<40){
                product.ProductCode = 'pro'+i;
                product.PFNPRIC_T__c = i;
                product.Name = 'name'+i;
                product.RecordTypeId = finish;
            }            
            productList.add(product);
        }
        insert productList;
        Test.startTest();
            UpdateProductExternalFieldIdBatch obj = new UpdateProductExternalFieldIdBatch();
            DataBase.executeBatch(obj); 
        Test.stopTest();        
    }
    
    public static testMethod void account(){
		List<Account> accountList= new List<Account>();
        for(Integer i=0 ;i <100;i++){
            Account acc = new Account();
            if(i<50){
                acc.Name ='Name'+i;
            	acc.PCSCUST__c = 'test'+i;
            }else if(i<70){
                acc.Name ='Name'+i;
            	acc.PHTCODE__c = 'test'+i;
            }else{
                acc.Name ='Name'+i;
            	acc.PBRBRN__c = 'test'+i;
            }
            
            accountList.add(acc);
        }
        insert accountList;
        Test.startTest();
            UpdateAccountExternalFieldIdBatch obj = new UpdateAccountExternalFieldIdBatch();
            DataBase.executeBatch(obj); 
        Test.stopTest();     
    }
    
}