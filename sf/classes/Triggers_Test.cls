@isTest(seeAllData=true)
public class Triggers_Test {
    static testMethod void trig()
    {
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> mapCaseRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        
        
        Id brandRecordTypeId = mapCaseRecordTypeInfo.get('Brand').getRecordTypeId();
        

        list <Special_Request__c> li = [select id, final_design_name__c from Special_Request__c order by createddate desc limit 1];
        if(!li.isEmpty())
            update li[0];
        Account acc = new Account(name = 'PK1');
        insert acc;
        Account acc2 = new Account (name = 'PK2');
        insert acc2;
        
        Account brn1 = new Account (name = 'brnd1');
		brn1.recordTypeID = brandRecordTypeId;
        insert brn1;
        
        Opportunity op = new opportunity();
        op.name = 'op1';

        op.Type = 'Non-Brand Development / Standard';
        op.Brand__c = brn1.id;
        op.City_Addl_Descriptor__c ='desc';
        op.AccountId = acc.id;
        op.Country__c = 'United States';
        op.State__c = 'Alabama';        
        op.Areas__c = 'Public Space'; 
        op.Purchaser_Account__c = acc2.id;
        op.StageName = 'Customer Approval';
        op.CloseDate = date.today()-5;
        insert op;
    }
}