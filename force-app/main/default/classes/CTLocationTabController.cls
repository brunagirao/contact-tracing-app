public with sharing class CTLocationTabController {
    @AuraEnabled
    public static LocationInfo getLocationDetails(String locationId){
        try {
            Location__c location  = CTLocationController.getLocationById(locationId);
            LocationInfo info = new LocationInfo();
            if(location != null) {
                info.name               = location.Name;
                info.address            = location.Address__c;
                info.pincode            = location.Pincode__c;
                info.redScore           = location.Red_Score__c;
                info.statusUpdateDate   = location.Status_Update_Date__c;
                info.status             = location.Status__c;
            }

            List<Location_Tracing__c> visitors = CTLocationTracingController.getVisitors(locationId);
            if(visitors != null && visitors.size() > 0) {
                List<VisitorInfo> vistorsInfo = new List<VisitorInfo>();
                for(Location_Tracing__c visitor : visitors) {
                    VisitorInfo vistorInfo  = new VisitorInfo();
                    vistorInfo.id           = visitor.Person__c;
                    vistorInfo.status       = visitor.Person__r.Health_Status__c;
                    vistorInfo.token        = visitor.Person__r.Token__c;
                    vistorInfo.visitDate    = visitor.Visit_Date__c;

                    vistorsInfo.add(vistorInfo);
                }
                info.vistorsInfo = vistorsInfo;
                info.vistorsInfoCount = vistorsInfo.size();
                System.debug('info.vistorsInfo  => ' + info.vistorsInfo );
            }
            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class LocationInfo {
        @AuraEnabled
        public String name; 
        @AuraEnabled
        public String address;
        @AuraEnabled
        public String pincode;
        @AuraEnabled
        public Decimal redScore;
        @AuraEnabled
        public Date statusUpdateDate;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public List<VisitorInfo> vistorsInfo;
        @AuraEnabled
        public Integer vistorsInfoCount = 0;

    }

    public class VisitorInfo {
        @AuraEnabled
        public String id; 
        @AuraEnabled
        public String status; 
        @AuraEnabled
        public String token;
        @AuraEnabled
        public Date visitDate;  
    }
}
