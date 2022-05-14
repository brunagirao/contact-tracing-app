public with sharing class CTUpdateStatusSchedule implements Schedulable{
    
    public static final String CRON = '0 0 3 * * ?';
    
    public static void execute(SchedulableContext sc){
        CTUpdatePersonStatusBatch updatePersonStatusBatch = new CTUpdatePersonStatusBatch();
        Database.executeBatch(updatePersonStatusBatch, 2000);

        CTUpdateLocationStatusBatch updateLocationStatusBatch = new CTUpdateLocationStatusBatch();
        Database.executeBatch(updateLocationStatusBatch, 2000);
    }
}
