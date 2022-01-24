trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    switch on Trigger.operationType {
        when AFTER_UPDATE {
            for(Project__c project: Trigger.new)
                BillingCalloutService.callBillingService(project.Status__c, project.ProjectRef__c, project.Billable_Amount__c);
        }
    }
}