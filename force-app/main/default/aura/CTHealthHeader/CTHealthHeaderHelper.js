({
    fetchStatusCount : function(component) {
        let scope = component.get("v.scope");
        let action = scope === "person" ? component.get("c.getPersonHealthStatusCount") : component.get("c.getLocationHealthStatusCount");
        
        action.setCallback(this, function (response) {
            let state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.count", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    }
})
