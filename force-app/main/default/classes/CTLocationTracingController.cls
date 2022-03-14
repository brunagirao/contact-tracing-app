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
}
