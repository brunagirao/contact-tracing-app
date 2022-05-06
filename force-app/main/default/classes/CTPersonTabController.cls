public with sharing class CTPersonTabController {
    
    @AuraEnabled
    public static UserInfo getPersonDetails(String personId){
        try {
            Person__c person = CTPersonController.getPersonById(personId);
            UserInfo info = new UserInfo();
            if(person != null) {
                info.name               = person.Name;
                info.token              = person.Token__c;
                info.status             = person.Health_Status__c;
                info.statusUpdateOn     = person.Status_Update_Date__c;
                info.phone              = person.Mobile__c;
            }

            List<People_Tracing__c> traces = CTPeopleTracingController.getTraces(personId);
            if(traces != null && traces.size() > 0) {

                List<UserInfoContacts> contacts = new List<UserInfoContacts>();
                Set<Id> uniqueIds = new Set<Id>();
                uniqueIds.add(personId);

                for(People_Tracing__c trace : traces) {
                    UserInfoContacts cc = new UserInfoContacts();
                    if(!uniqueIds.contains(trace.Person_1__c)) {
                        cc.id             = trace.Person_1__c;
                        cc.token          = trace.Person_1__r.Token__c;
                        cc.status         = trace.Person_1__r.Health_Status__c;
                        cc.contactDate    = trace.Contact_Date__c;
                    }

                    if(!uniqueIds.contains(trace.Person_2__c)) {
                        cc.id             = trace.Person_2__c;
                        cc.token          = trace.Person_2__r.Token__c;
                        cc.status         = trace.Person_2__r.Health_Status__c;
                        cc.contactDate    = trace.Contact_Date__c;
                    }
                    contacts.add(cc);
                }
                info.contacts       = contacts;
                info.contactCount   = contacts.size();
            }

            return info;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class UserInfo {
        @AuraEnabled 
        public String name;
        @AuraEnabled 
        public String token;
        @AuraEnabled 
        public String status;
        @AuraEnabled 
        public Date statusUpdateOn;
        @AuraEnabled 
        public String phone;
        @AuraEnabled 
        public Integer contactCount = 0;
        @AuraEnabled 
        public List<UserInfoContacts> contacts;
    }

    public class UserInfoContacts {
        @AuraEnabled 
        public String id;
        @AuraEnabled 
        public String token;
        @AuraEnabled 
        public String status;
        @AuraEnabled 
        public Date contactDate;
    }
}
