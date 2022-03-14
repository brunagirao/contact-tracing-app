/**
 * CTLocationTracingController
 * Main controller class for Location_Tracing__c object
 * @author Bruna Girão
 */
public with sharing class CTLocationTracingController {


    /**
    * Get last 30 days visitors
    * @param locationId 
    * @return List<Location_Tracing__c> 
    **/
    public static List<Location_Tracing__c> getVisitors(String locationId) {
        
        return [
                SELECT Id, Name, Person__c, Location__c, Visit_Date__c
                  FROM Location_Tracing__c
                 WHERE Id =: locationId
              ORDER BY Visit_Date__c DESC
        ];
    }

    /**
    * Get all location ids for visitors
    * @param personIds 
    * @return List<Location_Tracing__c> 
    **/
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds) {
        
        return [
                SELECT Id, Name, Person__c, Location__c, Visit_Date__c
                  FROM Location_Tracing__c
                 WHERE Person__c IN :personIds
                   AND Visit_Date__c = LAST_N_DAYS:10
        ];
    }

    /**
    * Get all visitor ids for locations
    * @param locationIds 
    * @return List<Location_Tracing__c> 
    **/
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds) {
        
        return [
                SELECT Id, Name, Person__c, Location__c, Visit_Date__c
                  FROM Location_Tracing__c
                 WHERE Location__c IN :locationIds
                   AND Person__r.Health_Status__c = 'Green'
                   AND Visit_Date__c = LAST_N_DAYS:10
        ];
    }
}
