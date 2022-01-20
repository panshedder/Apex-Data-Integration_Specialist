@isTest
public class ProjectCalloutServiceTest {
  //Implement mock callout tests here
  @TestSetup
  static void makeData(){
    Account account = new Account(Name = 'Test Account');
    insert account;

    List<Opportunity> opps = new List<Opportunity>();
    Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = System.today(), Amount=10000, AccountId = account.Id);
    opps.add(opp);

    insert opps;

    ServiceTokens__c servToken = new ServiceTokens__c();
    servToken.Name = 'Token__c';
    servToken.Token__c = 'test123534';
    insert servToken;
  }

  @isTest
  public static void postOpportunityToPMS_TestOk() {
    Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity'];

    List<Id> oppId = new List<Id>();
    oppId.add(opp.Id);

    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());

    Test.startTest();
      ProjectCalloutService.postOpportunityToPMS(oppId);
    Test.stopTest();

    Opportunity oppTest = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Test Opportunity'];

    System.assertEquals('Submitted Project', oppTest.StageName);
  }

  @isTest
  public static void postOpportunityToPMS_TestFailure() {
    Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity'];

    List<Id> oppId = new List<Id>();
    oppId.add(opp.Id);

    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());

    Test.startTest();
      ProjectCalloutService.postOpportunityToPMS(oppId);
    Test.stopTest();

    Opportunity oppTest = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Test Opportunity'];

    System.assertEquals('Resubmit Project', oppTest.StageName);
  }
}