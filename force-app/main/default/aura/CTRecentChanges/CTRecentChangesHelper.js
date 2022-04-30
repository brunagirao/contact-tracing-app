({
    fetchRecentHealthChanges: function (component, event, helper) {
        
       let action = component.get("v.scope") === "person" ? component.get("c.getRecentPersonHealthChanges") : component.get("c.getRecentLocationHealthChanges");

       action.setCallback(this, function (response) {
            const state = response.getState();

            if (state === "SUCCESS") {
                const data = response.getReturnValue();
                component.set("v.data", data);
            }
        });
        $A.enqueueAction(action);
    }

})
