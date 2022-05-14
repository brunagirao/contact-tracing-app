public with sharing class CTLocationTracingDataCleanupBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id FROM Location_Tracing__c WHERE Visit_Date__c < LAST_N_DAYS:30';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Location_Tracing__c> scope) {
        System.debug('Batch initialize!');
        System.debug('Records found to delete: ' + scope.size());
        delete scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch finish!');
    }
}
