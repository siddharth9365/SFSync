public class VFC001_BundlePrint {
    public string qId{get;set;}
    public SBQQ__Quote__c quot{get;set;}    
    public static decimal mainqladder;    
    public list<Product2> lPr{get;set;}    
    public list<prod> LProd{get;set;}    
    public static list<SBQQ__QuoteLine__c> QuoteLines = new list<SBQQ__QuoteLine__c>();
    public static list<SBQQ__ProductOption__c> lPo = new list<SBQQ__ProductOption__c>();
    
    public class attrRec
    {
        public string sLabel{get;set;}
        public string sValue{get;set;}
        public decimal dValue{get;set;}
        public string sPostFix{get;set;}
        
        public attrRec(string sLabel, string sValue,decimal dValue, string sPostFix)
        {
            this.sLabel = sLabel;
            this.sValue = sValue;
            this.dValue = dValue;
            if(sPostFix == null)
                sPostFix = '';
            this.sPostFix = sPostFix;
        }
    }
    public class prod
    {
        public Product2 pr{get;set;}
        public list<SBQQ__QuoteLine__c> ql{get;set;}
		public list<SBQQ__QuoteLine__c> qlShown{get;set;} 
		public list<SBQQ__QuoteLine__c> qlOne{get;set;}          
        public SBQQ__QuoteLine__c mainQL{get;set;}
        public string note{get;set;}
        public string color{get;set;}
        public string sMainProdName {get;set;}
		public list<attrRec> lAttr {get;set;}    

        public void putAttrMap(string sLabel,string sValue, decimal dValue, string sPostFix)
        {
            if((sValue != null && sValue != '' && sValue != 'null')
                ||(dValue != null && dValue != 0)
               )
            {
                lAttr.add(new attrRec(sLabel,sValue,dValue,sPostFix));
            }
        }
        public prod(Product2 pr, Map<SBQQ__QuoteLine__c, set<id>> mp)
        {
            this.pr = pr;
            if (pr.PCLUOM__c == null)
                pr.PCLUOM__c = 'Yards';
            this.ql = getql(mp); 
            this.qlShown = new list<SBQQ__QuoteLine__c>();
            this.mainQL = this.ql[0];
            this.qlOne = new list<SBQQ__QuoteLine__c>() ;
            sMainProdName = this.mainQL.SBQQ__Product__r.Name;
            for (SBQQ__QuoteLine__c q : this.ql)
            {                
                if (q.Color__c != null && q.Color__c != '')
            	{
                	this.color = q.Color__c;
                }
				if(q.SBQQ__ProductFamily__c == 'Colors' /* && q.SBQQ__NetPrice__c != 0*/)
                {
                    sMainProdName = q.SBQQ__Product__r.Name;
                }
                else
                {
                    qlShown.add(q);
                }
                if (q.SBQQ__RequiredBy__c == null)
                {
                    qlOne.add(q);
                }
            }
            this.note = this.mainQL.Line_Item_Note__c;
//            mAttr = new map<string,string>();

            lAttr = new list<attrRec>();
            
            putAttrMap('Spec/Item Number',this.MainQL.Customer_Item_Spec__c,null, null);
            putAttrMap('Area&amp;Application',this.MainQL.Application__c,null, null);  
            putAttrMap('Pattern',this.MainQL.Parent_Pattern__c,null, null);
            putAttrMap('Color',this.Color,null, null);
            putAttrMap('Intended Use',pr.PPTUSE__c,null, null);
            putAttrMap('Stock available',null,pr.PCLAVAIL__c, ' '+pr.PCLUOM__c);
            putAttrMap('Fiber Content', pr.PPTCONT__c,null, null);
            putAttrMap('Country of origin', pr.PPTCOUN__c,null, null);  
            putAttrMap('Width',null, pr.PPTWDTH__c,'\"'); 
            if(pr.PPTHREP__c != 0)
            	putAttrMap('Horizontal Repeat',null,pr.PPTHREP__c,'\"');
            if(pr.PPTVREP__c != 0)            
            	putAttrMap('Vertical Repeat',null,pr.PPTVREP__c,'\"');
            putAttrMap('Weight',null,pr.PPTWGHT__c,'gpm');
            putAttrMap('Finish',pr.PPTFIND__c,null, null);
            putAttrMap('# of Screens',null,pr.PPTSCR__c, null);
            putAttrMap('# of Rubs',pr.PPTABR__c,null, null);
            putAttrMap('Custom/Inline',pr.PPTDSTS__c,null, null);
            if((pr.PPTABR__c != null && pr.PPTABR__c != '') ||
               (pr.PPTFRTST__c != null && pr.PPTFRTST__c != '') ||
               (pr.PPTSUSTN__c != null && pr.PPTSUSTN__c != '')
              )
            {
                string strVal = '';
                if(pr.PPTABR__c!= null)
                    strVal+=(pr.PPTABR__c+'\n');
                if(pr.PPTFRTST__c!=null)
					strVal+=(pr.PPTFRTST__c+'\n');
                if(pr.PPTSUSTN__c != null)
					strVal+=(pr.PPTSUSTN__c); 
                putAttrMap('Test Results',strVal,null, null);              
            }

            putAttrMap('Current Lead time',null,pr.PPTLEAD__c, null);
            putAttrMap('FOB',pr.PPTMLNM__c,null, null);
        }
    }
    
    public static list<SBQQ__QuoteLine__c> getql(Map<SBQQ__QuoteLine__c,set<id>> Msid){
        set<SBQQ__QuoteLine__c> getqls = new set<SBQQ__QuoteLine__c>();
        list<SBQQ__QuoteLine__c> getql = new list<SBQQ__QuoteLine__c>();
        for (SBQQ__QuoteLine__c qlm : Msid.keySet())
        {
            mainqladder = 0;
            decimal netprice = 0;
            for (SBQQ__QuoteLine__c ql : QuoteLines)
            {
                if (Msid.get(qlm).contains(ql.id))
                {
                    
                    getqls.add(ql);                       
                    if (ql.SBQQ__RequiredBy__c != null)
                    {
                        mainqladder += ql.SBQQ__NetTotal__c/qlm.SBQQ__Quantity__c;
                        
                        ql.SBQQ__Quantity__c = null;
                        ql.SBQQ__Product__r.PCLUOM__c = null;
                    }
                    if(ql.SBQQ__ProductFamily__c == 'Colors')
                    {
                        netprice = ql.SBQQ__NetTotal__c/qlm.SBQQ__Quantity__c;
                    }
                }              
            }
            qlm.SBQQ__ComponentTotal__c=mainqladder;
 			qlm.SBQQ__NetPrice__c =  netprice;
        }
        getql.addAll(getqls);
        return getql;
    }
    
    public VFC001_BundlePrint() {
        qId = (Id)ApexPages.currentPage().getParameters().get('qid');
        
        if (qId != null)
        {
            quot = [SELECT id FROM SBQQ__Quote__c WHERE id =: qId];
            quotelines = [SELECT SBQQ__NetPrice__c, SBQQ__Product__c, SBQQ__Product__r.ProductCode, SBQQ__Product__r.PCLUOM__c, cvPackPrCode__c,
                          SBQQ__Product__r.Name, SBQQ__ProductOption__c, SBQQ__Quantity__c, SBQQ__RequiredBy__c, SBQQ__NetTotal__c,
                          Model_Room_Production__c, Customer_Item_Spec__c, Application__c, Color__c, Parent_Pattern__c, Line_Item_Note__c, SBQQ__ProductName__c, SBQQ__ProductFamily__c
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