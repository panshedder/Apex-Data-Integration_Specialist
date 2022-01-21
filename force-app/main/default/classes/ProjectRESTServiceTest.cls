@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
  @TestSetup
  static void createOpportunity(){
    Opportunity opportunity = new Opportunity();
    opportunity.Name = 'Test Oppty';
    opportunity.CloseDate = System.today();
    opportunity.StageName = 'Prospecting';
    opportunity.DeliveryInstallationStatus__c = 'Yet to begin';
    insert opportunity;
  }

  @isTest
  public static void postProjectData_TestOk() {
    Opportunity oppty = [SELECT Id, Name, DeliveryInstallationStatus__c FROM Opportunity WHERE Name = 'Test Oppty'];

    Test.startTest();
    String result = ProjectRESTService.postProjectData('ProjectRef', 'ProjectName', oppty.Id, System.today(), System.today() + 5, 123456, 'Running');
    Test.stopTest();

    Opportunity updatedOpportunity = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id =: oppty.Id];

    System.assertEquals('In progress', updatedOpportunity.DeliveryInstallationStatus__c);
    System.assertEquals('OK', result);
  }

  @isTest
  public static void postProjectData_TestFailure() {
    Opportunity oppty = [SELECT Id, Name, DeliveryInstallationStatus__c FROM Opportunity WHERE Name = 'Test Oppty'];

    Test.startTest();
    String result = ProjectRESTService.postProjectData('ProjectRef', 'ProjectName', oppty.Id + '2', System.today(), System.today() + 5, 123456, 'Running');
    Test.stopTest();

    Opportunity updatedOpportunity = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id =: oppty.Id];

    System.assertEquals('Yet to begin', updatedOpportunity.DeliveryInstallationStatus__c);
    System.assert('OK' != updatedOpportunity.DeliveryInstallationStatus__c);
  }
}