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
              ORDER BY Status_Update_Date__c DESC NULLS LAST
                 LIMIT 100
        ];
    }

    /**
     * Search a location by name, pincode or address
     * @param  searchTerm
     * @return List<Location__c>
     */
    public static List<Location__c> searchLocations(String searchTerm) {

        List<Location__c> locations = new List<Location__c>();

        if(String.isNotBlank(searchTerm)){
            searchTerm = searchTerm + '%';

            locations = [
                            SELECT Id,Name, Address__c, Pincode__c, Red_Score__c, 
                                   Status_Update_Date__c, Status__c
                              FROM Location__c
                             WHERE Name LIKE :searchTerm
                                OR Pincode__c LIKE :searchTerm
                                OR Address__c LIKE :searchTerm
                          ORDER BY Status_Update_Date__c DESC NULLS LAST
                        ];
        }

        return locations;
    }

    /**
    * Search a location by id
    * @param locationId 
    * @return Location__c 
    **/
    public static Location__c getLocationById(String locationId){
        
        List<Location__c> locations = new List<Location__c>();
        Location__c location = new Location__c();

        if(String.isNotBlank(locationId)) {

            locations = [
                            SELECT Id,Name, Address__c, Pincode__c, Red_Score__c, 
                                   Status_Update_Date__c, Status__c
                              FROM Location__c
                             WHERE Id =: locationId
                             LIMIT 1
                        ];
        }

        if(!locations.isEmpty()){
            location = locations.get(0);
        }

        return location;
    }

    /**
     * Get count of location in each health status
     * @return Map<String, Integer>
    */
    public static Map<String,Integer> getStatusCount() {

        Map<String,Integer> healthStatusCountMap = new Map<String,Integer>();

        for(AggregateResult result : [
             SELECT Status__c, COUNT(Id) Quantity
               FROM Location__c
           GROUP BY Status__c
        ]) {

            String status    = String.valueOf(result.get('Status__c'));
            Integer quantity = Integer.valueOf(result.get('Quantity'));

            healthStatusCountMap.put(status, quantity);

        }

        return healthStatusCountMap;
    }
}
