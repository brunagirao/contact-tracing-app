public with sharing class CTUpdatePersonStatusBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.today();
        Date fourteenDaysAgo = today - 14;
        List<String> healthStatuses = new List<String> {'Red', 'Orange', 'Yellow'};

        String query = 'SELECT Id, Health_Status__c '
                       + 'FROM Person__c '
                       +'WHERE Status_Update_Date__c =: fourteenDaysAgo '
                       +  'AND Health_Status__c IN: healthStatuses';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Person__c> scope) {
        System.debug('Batch initialize!');
        System.debug('Records found to update: ' + scope.size());
        
        for (Person__c person : scope) {
            person.Health_Status__c = 'Green';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch finish!');
    }
}
