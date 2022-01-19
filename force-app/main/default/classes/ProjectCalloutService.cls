global class ProjectCalloutService {
    //Complete the implementation for business and callout logic
	@InvocableMethod(Label='Post Opportunity To PMS')
    global static void postOpportunityToPMS(List<Opportunity> opp){
        JSONGenerator genBody = JSON.createGenerator(true);
        genBody.writeStartObject();
            genBody.writeStringField('opportunityId', opp[0].Id);
            genBody.writeStringField('opportunityName', opp[0].Name);
            genBody.writeStringField('accountName', opp[0].Account.Name);
            genBody.writeDateField('closeDate', opp[0].closeDate);
            genBody.writeNumberField('amount', opp[0].Amount);
        genBody.writeEndObject();

        String stringBody = genBody.getAsString();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ProjectService');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(stringBody);
        
        Http http = new Http();
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 201)
            System.debug(response.getBody());
        else if(response.getStatusCode() == 500)
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
    }
}