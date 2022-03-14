/**
 * CTLocationController
 * Main controller class for Location__c object
 * @author Bruna Girão
 */
public with sharing class CTLocationController {
    
    /**
     * Get 100 locations with recent status change
     * @return List<Location__c>
     */
    public static List<Location__c> getRecentStatusChange() {

        return [
                SELECT Id,Name, Address__c, Pincode__c, Red_Score__c, 
                       Status_Update_Date__c, Status__c
                  FROM Location__c
              ORDER BY Status_Update_Date__c DESC
                 LIMIT 100
        ];
    }
}
