global class ProjectCalloutService {
    //Complete the implementation for business and callout logic
	@InvocableMethod(Label='Post Opportunity To PMS')
    global static void postOpportunityToPMS(Id opportunityId, String opportunityName, String accountName, Date closeDate, Integer amount){
        JSONGenerator genBody = JSON.createGenerator(true);
        genBody.writeStartObject();
            genBody.writeStringField(opportunityId, opportunityId);
            genBody.writeStringField(opportunityName, opportunityName);
            genBody.writeStringField(accountName, accountName);
            genBody.writeDateField(closeDate, closeDate);
            genBody.writeNumberField(amount, amout);
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