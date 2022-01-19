global class ProjectCalloutService {
    //Complete the implementation for business and callout logic
	@InvocableMethod(Label='Post Opportunity To PMS')
    global static void postOpportunityToPMS(List<Opportunity> opp){
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ProjectService');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"opportunityId": opp.Id, "opportunityName": opp.Name, "accountName": opp.AccountId.Name, "closeDate": opp.CloseDate, "amount":  opp.Amount}');
        
        Http http = new Http();
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 201)
            System.debug(response.getBody());
        else if(response.getStatusCode() == 500)
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
    }
}