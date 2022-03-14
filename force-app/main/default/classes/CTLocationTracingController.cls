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

    /**
    * Check duplicate location traces
    * @param newLocationTraces 
    * @return List<Location_Tracing__c> 
    **/
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces) {

        //store unique person and location ids
        Set<Id> personIds   = new Set<Id>();
        Set<Id> locationIds = new Set<Id>();
        
        for(Location_Tracing__c trace : newLocationTraces) {
            personIds.add(trace.Person__c);
            locationIds.add(trace.Location__c);
        }

        //get existing location traces 
        List<Location_Tracing__c> existingLocationTraces = [
               SELECT Id, Person__c, Location__c
                 FROM Location_Tracing__c
                WHERE Person__c IN :personIds
                  AND Location__c IN :locationIds
        ];

        //map of location id, set of person ids
        //location1, [person1, person2]
        Map<Id, Set<Id>> locationTracesMap = new Map<Id, Set<Id>>();
        //list to store duplicates records
        List<Location_Tracing__c> locationDuplicates = new List<Location_Tracing__c>();

        if(existingLocationTraces != null && !existingLocationTraces.isEmpty()) {
            for (Location_Tracing__c existingTrace : existingLocationTraces) {
                if(!locationTracesMap.containsKey(existingTrace.Location__c)) {
                  locationTracesMap.put(existingTrace.Location__c, new Set<Id>());
                }
                //add person ids to map set
                locationTracesMap.get(existingTrace.Location__c).add(existingTrace.Person__c);
            }

            //loop over new location tracing records
            for(Location_Tracing__c newTrace : newLocationTraces){
                //first check for location id
                //if item found in map, then check for person in set
                if(locationTracesMap.containsKey(newTrace.Location__c)
                    && locationTracesMap.get(newTrace.Location__c).contains(newTrace.Person__c)) {
                      locationDuplicates.add(newTrace);
                }
            }
        }
        
        return locationDuplicates;
    }
}
