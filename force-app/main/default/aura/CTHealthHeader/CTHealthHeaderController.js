({
    createRecord: function (component, event, helper) {
        let scope = component.get("v.scope");
        let createRecordEvent = $A.get("e.force:createRecord");

        createRecordEvent.setParams({
            "entityApiName": scope === "person" ? "Person__c" : "Location__c",
        });
        createRecordEvent.fire();
    },

    doInit: function (component, event, helper) {
        helper.fetchStatusCount(component);
    }
})
