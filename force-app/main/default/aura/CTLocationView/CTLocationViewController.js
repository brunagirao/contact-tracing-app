({
    locationSelectHandler: function(component, event, helper) {
        let recordId = event.getParam("recordId");
        let status = event.getParam("status");

        component.set("v.recordId", recordId);
        component.set("v.status", status);
    }
})
