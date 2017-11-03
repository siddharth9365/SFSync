public class VFC003_Header {
    public string qId{get;set;}
    public SBQQ__Quote__c quot{get;set;}
    public string today{get;set;}
    public static User us{get;set;}
    
    public VFC003_Header() {
        qId = (Id)ApexPages.currentPage().getParameters().get('qid');
        if (qId != null)
        {
            quot = [SELECT id, Name, SBQQ__SalesRep__c, SBQQ__PrimaryContact__r.LastName, SBQQ__PrimaryContact__r.FirstName, SBQQ__Account__r.Name, SBQQ__Opportunity2__r.Name FROM SBQQ__Quote__c q WHERE id =: qId];
        }
        today = System.Date.today().format();
        list<User> lus = [SELECT id, LastName, FirstName, Email, Phone FROM User WHERE id =: quot.SBQQ__SalesRep__c];
        if (!lus.isEmpty())
            us = lus[0];
    }

}