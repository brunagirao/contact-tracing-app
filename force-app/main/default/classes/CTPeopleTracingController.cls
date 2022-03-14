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
                       Person_1__c, Person_2__c
                  FROM People_Tracing__c
                 WHERE Person_1__c = :recordId
                    OR Person_2__c = :recordId
              ORDER BY Contact_Date__c DESC
            ];
        }

        return peopleTraces;
    }
}
