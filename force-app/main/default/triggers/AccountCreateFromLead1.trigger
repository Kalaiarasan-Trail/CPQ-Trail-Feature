trigger AccountCreateFromLead1 on Lead (before insert) {
set<string> emailid=new set<string>();
list<account> acclist = new list<account>();
    for(lead l:trigger.new){
        emailid.add(l.Email);
        system.debug('The newly created leads are'+emailid);
    }
    list<Account> accdata=new list<Account>();
    accdata=[Select id,Name,Email__c from Account where Email__c in:emailid];
    system.debug('The acc data match with new lead data'+accdata);
    map<string,account> emailmap=new map<string,account>();
    if(accdata.size()>0)
    {
        for(Account a:accdata){
            emailmap.put(a.Email__c, a);
            system.debug('The map value is'+emailmap.get(a.Email__c));
        }
    }
    if(emailmap!=null&&emailmap.size()>0){
        for(lead l:trigger.new){
            if(emailmap.containsKey(l.Email)){
                account a=new account();
                a=emailmap.get(l.Email);
                a.Name=l.LastName;
                acclist.add(a);
            }else{
                account a=new account();
                a.Email__c=l.Email;
                a.Name=l.LastName;
                acclist.add(a);
            }
        }
        if(acclist.size()>0){
            upsert acclist;
        }
    }
}