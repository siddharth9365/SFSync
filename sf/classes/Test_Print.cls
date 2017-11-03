@isTest(SeeAllData=true)
public class Test_Print {

    	static testMethod void Printtest()
        {
            list<SBQQ__Quote__c> q = [SELECT id FROM SBQQ__Quote__c LIMIT 1];
            ApexPages.currentPage().getParameters().put('qid', q[0].id);
            VFC001_BundlePrint ctrl1 = new VFC001_BundlePrint();
            VFC002_UnBundlePrint ctrl2 = new VFC002_UnBundlePrint();
            VFC003_Header ctrl3 = new VFC003_Header();
        }
}