@RestResource(urlMapping = '/project/*')
global without sharing class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, 
                                        Date StartDate, Date EndDate, Double Amount, String Status) {                 
        Savepoint sp = Database.setSavepoint();
                                            
        try {
            Project__c newProject = new Project__c();
            newProject.ProjectRef__c = ProjectRef;
            newProject.Name = ProjectName;
            newProject.Opportunity__c = OpportunityId;
            newProject.Start_Date__c = StartDate;
            newProject.End_Date__c = EndDate;
            newProject.Billable_Amount__c = Amount;
            newProject.Status__c = Status;
            upsert newProject ProjectRef__c;

            Opportunity relatedOpportunity = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id =: OpportunityId LIMIT 1];
            relatedOpportunity.DeliveryInstallationStatus__c = 'In progress';
            update relatedOpportunity;

            return 'OK';
        } catch (Exception e) {
            Database.rollback(sp);
            return e.getMessage();
        }
    }
}