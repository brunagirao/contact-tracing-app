/**
 * CTPeopleTracingController
 * Main controller class for People_Tracing__c object
 * @author Bruna Girão
 */
public with sharing class CTPeopleTracingController {
    
    /**
    * Return people traces
    * @param recordId 
    * @return List<People_Tracing__c> 
    **/
    public static List<People_Tracing__c> getTraces(String recordId) {

        List<People_Tracing__c> peopleTraces = new List<People_Tracing__c>();

        if(String.isNotBlank(recordId)) {

            peopleTraces = [
                SELECT Id, Name, Contact_Date__c, Contact_Type__c, 
                       Person_1__c, Person_1__r.Token__c, Person_1__r.Health_Status__c,
                       Person_2__c, Person_2__r.Token__c, Person_2__r.Health_Status__c
                  FROM People_Tracing__c
                 WHERE (Person_1__c = :recordId
                    OR Person_2__c = :recordId)
              ORDER BY Contact_Date__c DESC
            ];
        }

        return peopleTraces;
    }

    /**
    * Check duplicate people traces
    * @param newPeopleTraces 
    * @return List<People_Tracing__c> 
    **/
    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces) {

         //store unique person1 and person2 ids
        Set<Id> person1Ids = new Set<Id>();
        Set<Id> person2Ids = new Set<Id>();

        for(People_Tracing__c newTrace : newPeopleTraces) {
            person1Ids.add(newTrace.Person_1__c);
            person2Ids.add(newTrace.Person_2__c);
        }

        //get existing people traces 
        List<People_Tracing__c> existingPeopleTraces = [
            SELECT Id, Name, Contact_Date__c, Contact_Type__c, 
                       Person_1__c, Person_2__c
                  FROM People_Tracing__c
                 WHERE Person_1__c IN :person1Ids
                   AND Person_2__c IN :person2Ids
        ];
        
        //map of person1 id, set of person2 ids
        //person1, [person2, person2]
        Map<Id, Set<Id>> peopleTracesMap = new Map<Id, Set<Id>>();
        //list to store duplicates records
        List<People_Tracing__c> peopleDuplicates = new List<People_Tracing__c>();

        if(existingPeopleTraces != null && !existingPeopleTraces.isEmpty()) {
            for(People_Tracing__c existingTrace : existingPeopleTraces){
                if(!peopleTracesMap.containsKey(existingTrace.Person_1__c)) {
                    peopleTracesMap.put(existingTrace.Person_1__c, new Set<Id>());
                }
                //add person2 ids to map set
                peopleTracesMap.get(existingTrace.Person_1__c).add(existingTrace.Person_2__c);
            }

            //loop over new people tracing records
            for(People_Tracing__c newTrace : newPeopleTraces) {
                //first check for person1 id
                //if item found in map, then check for person2 in set
                if(peopleTracesMap.containsKey(newTrace.Person_1__c) 
                    && peopleTracesMap.get(newTrace.Person_1__c).contains(newTrace.Person_2__c)) {
                        peopleDuplicates.add(newTrace);
                    }
            }
        }

        return peopleDuplicates;
    }
}
