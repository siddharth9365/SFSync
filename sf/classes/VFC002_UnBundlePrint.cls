public class VFC002_UnBundlePrint {
 	public string qId{get;set;}
    public SBQQ__Quote__c quot{get;set;}
    public static decimal mainqladder;    
    public list<Product2> lPr{get;set;}    
    public list<prod> LProd{get;set;}    
    public static list<SBQQ__QuoteLine__c> QuoteLines = new list<SBQQ__QuoteLine__c>();
    public static list<SBQQ__ProductOption__c> lPo = new list<SBQQ__ProductOption__c>();
    public static string pcolor;
    
    public class prod{
        public Product2 pr{get;set;}
        public list<SBQQ__QuoteLine__c> ql{get;set;}
        public SBQQ__QuoteLine__c mainQL{get;set;}
        public string color{get;set;}

        public prod(Product2 pr, Map<SBQQ__QuoteLine__c, set<id>> mp)
        {
            this.pr = pr;
            if (pr.PCLUOM__c == null)
                pr.PCLUOM__c = 'Yards';
            this.ql = getql(mp);
            this.mainQL = this.ql[0];
            this.color = pcolor;
        }
    }
    
    public static list<SBQQ__QuoteLine__c> getql(Map<SBQQ__QuoteLine__c,set<id>> Msid){
        set<SBQQ__QuoteLine__c> getqls = new set<SBQQ__QuoteLine__c>();
        list<SBQQ__QuoteLine__c> getql = new list<SBQQ__QuoteLine__c>();
        pcolor = '';
        for (SBQQ__QuoteLine__c qlm : Msid.keySet())
        { 
            list<SBQQ__QuoteLine__c> checkql = new list<SBQQ__QuoteLine__c>();
            mainqladder = 0;
            for (SBQQ__QuoteLine__c ql : QuoteLines)
                if (Msid.get(qlm).contains(ql.id))
                {
                    checkql.add(ql);
                    getqls.add(ql);
                }
            for (SBQQ__QuoteLine__c ql : checkql)
            {
                if (ql.Color__c != null && ql.Color__c != '')
                    pcolor = ql.Color__c;
                for (SBQQ__ProductOption__c po : lPo)
                {
                    if (ql.SBQQ__ProductOption__c == po.id)
                        {
                            getqls.remove(ql);
                            mainqladder += ql.SBQQ__NetTotal__c/qlm.SBQQ__Quantity__c;
                        }
                }
            }
            qlm.SBQQ__NetPrice__c+=mainqladder;
        }
        getql.addAll(getqls);
        return getql;
    }
    
    public VFC002_UnBundlePrint() {
        qId = (Id)ApexPages.currentPage().getParameters().get('qid');
        
        if (qId != null)
        {
            quot = [SELECT id FROM SBQQ__Quote__c q WHERE id =: qId];
            quotelines = [SELECT SBQQ__NetPrice__c, SBQQ__Product__c, SBQQ__Product__r.ProductCode, SBQQ__Product__r.PCLUOM__c, cvPackPrCode__c,
                          SBQQ__Product__r.Name, SBQQ__ProductOption__c, SBQQ__Quantity__c, SBQQ__RequiredBy__c, SBQQ__NetTotal__c,
                          Model_Room_Production__c, Customer_Item_Spec__c, Application__c, Color__c, Parent_Pattern__c, Line_Item_Note__c
                          FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :qId]; 
            for(SBQQ__QuoteLine__c rec : quotelines)
            {
                if(rec.SBQQ__RequiredBy__c == null && rec.SBQQ__Product__r.PCLUOM__c == null || rec.SBQQ__Product__r.PCLUOM__c =='')
                {
                    rec.SBQQ__Product__r.PCLUOM__c = 'Yards';
                }
            }
        }else return;
        
        set<id> sProdId = new set<id>();
        set<string> packprocode = new set<string>();
        set<id> sOptionId = new set<id>();
        map<id,Product2> mppack = new map<id,Product2>();
        for (SBQQ__QuoteLine__c ql : quotelines)
        {
            if (ql.SBQQ__Product__c != null && ql.SBQQ__ProductOption__c == null)
            {
            	sProdId.add(ql.SBQQ__Product__c);
                packprocode.add(ql.cvPackPrCode__c);
                //mppack.put(ql.cvPackPrCode__c,ql.SBQQ__Product__c);
            }else if (ql.SBQQ__Product__c != null && ql.SBQQ__ProductOption__c != null)
            {
                sOptionId.add(ql.SBQQ__ProductOption__c);
            }
        } 
		lPr = [SELECT id, PPTUSE__c, PPTCONT__c, PPTCOUN__c, PPTWDTH__c,
               PPTHREP__c, PPTVREP__c, PPTWGHT__c, PPTSCR__c, PPTLEAD__c,
               PPTFIND__c, PCLDSTS__c, PPTABR__c, PPTFRTST__c, PPTSUSTN__c ,
               PCLAVAIL__c, PPTMLNM__c, PCLUOM__c, PPTDSTS__c
               FROM Product2 WHERE id in: sProdId]; 
        lPo = [SELECT id, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c, SBQQ__QuoteLineVisibility__c FROM SBQQ__ProductOption__c WHERE id in: sOptionId];
        
        for (Product2 pr : lpr)
        {
            mppack.put(pr.id,pr);
        }
        
        list<prod> LProdst = new list<prod>();
        for (string main : packprocode)//(Product2 main : lPr)
        {
           	Map<SBQQ__QuoteLine__c,set<id>> tmpMap = new Map<SBQQ__QuoteLine__c,set<id>>();
            Product2 pr = new Product2();
            list<SBQQ__QuoteLine__c> lines = new list<SBQQ__QuoteLine__c>();
            for (SBQQ__QuoteLine__c line : quotelines)
            {
                if (line.cvPackPrCode__c == main && line.SBQQ__RequiredBy__c == null)
                    lines.add(line);
            }
            for (SBQQ__QuoteLine__c line : lines)
            {
                set<id> sLineId = new set<id>();
                sLineId.add(line.id);
            	tmpMap.put(line,sLineId);
                pr = mppack.get(line.SBQQ__Product__c);
            }
            
            for (SBQQ__QuoteLine__c line : tmpMap.keySet())
            {
                for (SBQQ__QuoteLine__c ql : quotelines)
                {
                    if(tmpMap.get(line).contains(ql.SBQQ__RequiredBy__c))
                       tmpMap.get(line).add(ql.id);
                }
            }
            prod newPr = new prod(pr,tmpMap);
            LProdst.add(newPr);
    	}
        LProd = LProdst;
    }
}