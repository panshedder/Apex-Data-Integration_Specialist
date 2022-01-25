@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here
  @TestSetup
  static void makeProject(){
    ServiceCredentials__c servCred = new ServiceCredentials__c();
    servCred.Name = 'BillingServiceCredential';
    servCred.Username__c = 'usr1';
    servCred.Password__c = 'pwd1';
    insert servCred;

    Opportunity opp = new Opportunity();
    opp.Name = 'Opportunity Test class';
    opp.CloseDate = System.today();
    opp.StageName = 'Qualification';
    insert opp;
    
    Project__c project = new Project__c();
    project.Name = 'Test class project';
    project.Opportunity__c = opp.Id;
    project.Status__c = 'Billable';
    project.ProjectRef__c = 'codetest1234';
    project.Billable_Amount__c = 10000;
    insert project;
  }
  
  @isTest static void callBillingService_TestOk() {
    Project__c project = [SELECT Id, nAME, Status__c, ProjectRef__c, Billable_Amount__c 
                          FROM Project__c WHERE Name = 'Test class project'];
    
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

    Test.startTest();
      BillingCalloutService.callBillingService(project.Status__c, project.ProjectRef__c, project.Billable_Amount__c);
      project.Status__c = 'Billed';
      update project;
    Test.stopTest();
      
    List<Project__c> updatedProject = [SELECT Id, ProjectRef__c, Status__c FROM Project__c WHERE Id =: project.Id];
   
    System.assertEquals('Billed', updatedProject[0].Status__c);
  }

  @isTest static void callBillingService_TestFailure() {
    Project__c project = [SELECT Id, Name, Status__c, ProjectRef__c, Billable_Amount__c 
                                                FROM Project__c WHERE Name = 'Test class project'];
    
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());

    Test.startTest();
      BillingCalloutService.callBillingService(project.Status__c, project.ProjectRef__c, project.Billable_Amount__c);
    Test.stopTest();
      
    List<Project__c> updatedProject = [SELECT Id, ProjectRef__c, Status__c FROM Project__c WHERE Id =: project.Id];
   
    System.assertEquals('Billable', updatedProject[0].Status__c);
  }
}