global class BillingCalloutService {
    //Implement business and callout logic methods here
    @Future(callout = true)
    global static void callBillingService(String status, String projectRef, Decimal billAmount) {
        
        if(status == 'Billable') {
            try {
                BillingServiceProxy.project project = new BillingServiceProxy.project();
                project.username = ServiceCredentials__c.getAll().values().Username__c;
                project.password = ServiceCredentials__c.getAll().values().Password__c;
                project.projectid = projectRef;
                project.billAmount = billAmount;

                BillingServiceProxy.InvoicesPortSoap11 syncBilling = new BillingServiceProxy.InvoicesPortSoap11();
                String resp = syncBilling.billProject(project);

                if(resp == 'OK') {
                    Project__c projectUpd = [SELECT Id, Status__c, ProjectRef__c FROM Project__c WHERE ProjectRef__c =: projectRef];
                    projectUpd.Status__c = 'Billed';
                    update projectUpd;
                }
            } catch (Exception e) {
                System.debug('An error occurs: ' + e.getMessage());
            }
        }
    }
}