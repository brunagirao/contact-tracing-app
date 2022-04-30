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
    public static List<Location__c> getRecentStatusChanges() {

        return [
                SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, 
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
    public static Map<String,Integer> getHealthStatusCount() {

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

    /**
    * Update the RedScore and Status locations
    * @param locationIds 
    **/
    public static void updateRedScore(Set<Id> locationIds) {

        List<Location__c> locationsToUpdate = new List<Location__c>();
        //get the location and total of people in red status 
        List<AggregateResult> redPeoplePerLocation = [
            SELECT Location__c, COUNT(Id) Total 
              FROM Location_Tracing__c
             WHERE Location__c IN :locationIds
               AND Person__r.Health_Status__c = 'Red'
               AND Visit_Date__c = LAST_N_DAYS :10
          GROUP BY Location__c 
        ];

        //get the total of people, location status information
        for(AggregateResult result : redPeoplePerLocation) {
            String locationId     = String.valueOf(result.get('Location__c'));
            Integer redScore      = Integer.valueOf(result.get('Total'));
            String locationStatus = getLocationStatus(redScore);
            //add the location information 
            locationsToUpdate.add(new Location__c(
                Id           = locationId, 
                Red_Score__c = redScore, 
                Status__c    = locationStatus)
            );
        }
        //update the locations
        if(!locationsToUpdate.isEmpty()) {
            update locationsToUpdate;
        }

    }

    /**
    * Return the location status based on the redScore value
    * @param redScore 
    * @return String 
    **/
    public static String getLocationStatus(Integer redScore) {

        if(redScore == 0) {
            return 'Green';
        } else if (redScore <= 5) {
            return 'Yellow';
        } else if (redScore <= 10) {
            return 'Orange';
        } else {
            return 'Red';
        }
    }
}