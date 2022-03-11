/**
 * CTPersonController
 * Main controller class for Person__c object
 * @author Bruna Girão
 */
public with sharing class CTPersonController {
    
     /**
     * generate unique token using mobile number
     * use MD5 algorithm to generate one-way hash
     * @param  mobile
     * @return String token
     */
    public static String getToken(String mobile) {
        
        String token = '';   

        if(String.isNotEmpty(mobile)) {
            Blob target = Blob.valueOf(mobile);
            Blob hash   = Crypto.generateDigest('MD5', target);

            token  = EncodingUtil.base64Encode(hash);
        }
        
        return token;
    }

    /**
     * Get 100 contacts with recent health status change
     * @return List<Person__c>
     */
    public static List<Person__c> getRecentHealthChanges() {

        return [
                    SELECT Id, Name, Health_Status__c, Mobile__c, 
                           Status_Update_Date__c, Token__c
                      FROM Person__c
                  ORDER BY Status_Update_Date__c DESC NULLS LAST
                     LIMIT 100
                ];
    }

    /**
     * Search a person by name, token or mobile
     * @param  searchTerm
     * @return List<Person__c>
     */
    public static List<Person__c> searchPeople(String searchTerm) {
        
        List<Person__c> people = new List<Person__c>();
        
        if(String.isNotEmpty(searchTerm)) {
            searchTerm = searchTerm + '%';

            people = [
                        SELECT Id, Name, Health_Status__c, Mobile__c, 
                               Status_Update_Date__c, Token__c
                          FROM Person__c
                         WHERE Name LIKE: searchTerm 
                            OR Mobile__c LIKE: searchTerm
                            OR Token__c  LIKE: searchTerm
                      ORDER BY Status_Update_Date__c DESC NULLS LAST
                    ];
        }

        return people;
    }

    /**
     * Search a person by id
     * @param personId
     * @return Person__c
     */
    public static Person__c getPersonById(String personId) {

        List<Person__c> people = new List<Person__c>();
        Person__c person = new Person__c();

        if(String.isNotEmpty(personId)) {

            people = [
                        SELECT Id, Name, Health_Status__c, Mobile__c, 
                               Status_Update_Date__c, Token__c
                          FROM Person__c
                         WHERE Id =: personId
                         LIMIT 1
                    ];
        }

        if(!people.isEmpty()){
            person = people.get(0);
        }

        return person;
    }
}