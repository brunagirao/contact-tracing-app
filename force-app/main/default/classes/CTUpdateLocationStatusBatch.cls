public with sharing class CTUpdateLocationStatusBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.today();
        Date fourteenDaysAgo = today - 14;
        List<String> healthStatuses = new List<String> {'Red', 'Orange', 'Yellow'};

        String query = 'SELECT Id, Status__c '
                       + 'FROM Location__c '
                       +'WHERE Status_Update_Date__c =: fourteenDaysAgo '
                       +  'AND Status__c IN: healthStatuses';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Location__c> scope) {
        System.debug('Batch initialize!');
        System.debug('Records found to update: ' + scope.size());
        
        for (Location__c location : scope) {
            location.Status__c = 'Green';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch finish!');
    }
}
