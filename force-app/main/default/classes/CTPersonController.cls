public with sharing class CTPersonController {
    
    public static String getToken(String mobile) {
        
        String token = '';   

        if(String.isNotEmpty(mobile)) {
            Blob target = Blob.valueOf(mobile);
            Blob hash   = Crypto.generateDigest('MD5', target);

            token  = EncodingUtil.base64Encode(hash);
        }
        
        return token;
    }

    public static List<Person__c> getRecentHealthChanges() {

        List<Person__c> personList = [
                SELECT Id, Name, Health_Status__c, Mobile__c, 
                       Status_Update_Date__c, Token__c
                  FROM Person__c
              ORDER BY Status_Update_Date__c DESC
                 LIMIT 100
        ];

        return personList;
    }

    public static List<Person__c> searchPeople(String searchTerm) {

        List<Person__c> personList = new List<Person__c>();
        
        if(String.isNotEmpty(searchTerm)) {

            personList = [
                            SELECT Id, Name, Health_Status__c, Mobile__c, 
                                    Status_Update_Date__c, Token__c
                                FROM Person__c
                                WHERE Name =: searchTerm 
                                OR Mobile__c =: searchTerm
                                OR Token__c  =: searchTerm
                            ORDER BY Status_Update_Date__c DESC
                        ];
        }

        return personList;
    }

    public static Person__c getPersonById(String personId) {

        List<Person__c> personList = new List<Person__c>();
        Person__c person = new Person__c();

        if(String.isNotEmpty(personId)) {

            personList = [
                        SELECT Id, Name, Health_Status__c, Mobile__c, 
                               Status_Update_Date__c, Token__c
                          FROM Person__c
                         WHERE Id =: personId
                         LIMIT 1
                    ];
        }

        if(!personList.isEmpty()){
            person = personList.get(0);
        }

        return person;
    }
}
