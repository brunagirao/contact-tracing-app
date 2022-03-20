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

     /**
     * Get count of people in each health status
     * @return Map<String, Integer>
     */
    public static Map<String, Integer> getHealthStatusCount() {

        Map<String, Integer> healthStatusCountMap = new Map<String, Integer>();

        for(AggregateResult result : [
                SELECT Health_Status__c, COUNT(Id) Quantity
                  FROM Person__c
              GROUP BY Health_Status__c
        ]) {
            
            String status    = String.valueOf(result.get('Health_Status__c'));
            Integer quantity = Integer.valueOf(result.get('Quantity'));
            
            healthStatusCountMap.put(status, quantity);
        }

        return healthStatusCountMap;
    }

    /**
    * Get the cohabitants of a person list  
    * @param personIdsList 
    * @return Set<Id> 
    **/
    public static Set<Id> getCohabitants(List<Id> personIdsList) {
        //set of status to get cohabitants
        Set<String> healthStatusSet = new Set<String>{'Green', 'Yellow'};

        //get the list of cohabitant 
        List<People_Tracing__c> peopleTracesList = [
            SELECT Id, Contact_Date__c, Contact_Type__c, 
                   Person_1__c, Person_2__c
              FROM People_Tracing__c
             WHERE (Person_1__c IN: personIdsList 
                OR  Person_2__c IN: personIdsList)
               AND Contact_Type__c = 'Cohabitant'
               AND (Person_1__r.Health_Status__c IN: healthStatusSet 
                OR  Person_2__r.Health_Status__c IN: healthStatusSet)
        ];
         
        Set<Id> cohabitantsSet = new Set<Id>();

        //filter only the cohabitants
        for(People_Tracing__c pt : peopleTracesList) {
            if(!personIdsList.contains(pt.Person_1__c)) {
                cohabitantsSet.add(pt.Person_1__c);
            }
            if(!personIdsList.contains(pt.Person_2__c)) {
                cohabitantsSet.add(pt.Person_2__c);
            }
        }

        return cohabitantsSet;
    }

    /**
    * Get the neighborhoods of a person list  
    * @param personIdsList 
    * @return Set<Id> 
    **/
    public static Set<Id> getNeighbour(Set<Id> personIdsList) {
        //set of status to get neighbour
        Set<String> healthStatusSet = new Set<String>{'Green'};

        //get the list of neighbour 
        List<People_Tracing__c> peopleTracesList = [
            SELECT Id, Contact_Date__c, Contact_Type__c, 
                   Person_1__c, Person_2__c
              FROM People_Tracing__c
             WHERE (Person_1__c IN: personIdsList 
                OR  Person_2__c IN: personIdsList)
               AND Contact_Type__c = 'Neighbour'
               AND (Person_1__r.Health_Status__c IN: healthStatusSet 
                OR  Person_2__r.Health_Status__c IN: healthStatusSet)
        ];

        Set<Id> neighborhoodsSet = new Set<Id>();

        //filter only the neighbour
        for(People_Tracing__c pt : peopleTracesList) {
            if(!personIdsList.contains(pt.Person_1__c)) {
                neighborhoodsSet.add(pt.Person_1__c);
            }
            if(!personIdsList.contains(pt.Person_2__c)) {
                neighborhoodsSet.add(pt.Person_2__c);
            }
        }

        return neighborhoodsSet;
    }

    /**
    * Get the primary contacts of a person list  
    * @param personIdsList 
    * @return Set<Id> 
    **/
    public static Set<Id> getPrimaryContacts(Set<Id> personIdsList) {
        //set of status to get primary contacts
        Set<String> healthStatusSet = new Set<String>{'Green', 'Yellow'};

        //get the list of primary contacts
        List<People_Tracing__c> peopleTracesList = [
            SELECT Id, Contact_Date__c, Contact_Type__c, 
                   Person_1__c, Person_2__c
              FROM People_Tracing__c
             WHERE (Person_1__c IN: personIdsList 
                OR  Person_2__c IN: personIdsList)
               AND Contact_Type__c = 'Other'
               AND Contact_Date__c = LAST_N_DAYS:10
               AND (Person_1__r.Health_Status__c IN: healthStatusSet 
                OR  Person_2__r.Health_Status__c IN: healthStatusSet)
        ];

        Set<Id> primaryContactsSet = new Set<Id>();

        //filter only the primary contacts
        for(People_Tracing__c pt : peopleTracesList) {
            if(!personIdsList.contains(pt.Person_1__c)) {
                primaryContactsSet.add(pt.Person_1__c);
            }
            if(!personIdsList.contains(pt.Person_2__c)) {
                primaryContactsSet.add(pt.Person_2__c);
            }
        }

        return primaryContactsSet;
    }

    /**
    * Get the secondary contacts of a person list  
    * @param primaryContactsIdsList 
    * @return Set<Id> 
    **/
    public static Set<Id> getSecondayContacts(Set<Id> primaryContactsIdsList) {
        //set of status to get primary contacts
        Set<String> healthStatusSet = new Set<String>{'Green', 'Yellow'};

        //get the list of primary contacts
        List<People_Tracing__c> peopleTracesList = [
            SELECT Id, Contact_Date__c, Contact_Type__c, 
                   Person_1__c, Person_2__c
              FROM People_Tracing__c
             WHERE (Person_1__c IN: primaryContactsIdsList 
                OR  Person_2__c IN: primaryContactsIdsList)
               AND Contact_Type__c = 'Other'
               AND Contact_Date__c = LAST_N_DAYS:10
               AND (Person_1__r.Health_Status__c IN: healthStatusSet 
                OR  Person_2__r.Health_Status__c IN: healthStatusSet)
        ];

        Set<Id> secondaryContactsSet = new Set<Id>();

        //filter only the primary contacts
        for(People_Tracing__c pt : peopleTracesList) {
            if(!primaryContactsIdsList.contains(pt.Person_1__c)) {
                secondaryContactsSet.add(pt.Person_1__c);
            }
            if(!primaryContactsIdsList.contains(pt.Person_2__c)) {
                secondaryContactsSet.add(pt.Person_2__c);
            }
        }

        return secondaryContactsSet;
    }
}