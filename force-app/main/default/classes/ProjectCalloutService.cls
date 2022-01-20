global class ProjectCalloutService {
    //Complete the implementation for business and callout logic
	@InvocableMethod(Label='Post Opportunity To PMS')
    public static void postOpportunityToPMS(List<Id> oppId){
        QueueablePMSCall calloutAsyncJob = new QueueablePMSCall(oppId);
        Id JobID = System.enqueueJob(calloutAsyncJob);
    }

    global Class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        private Opportunity opp;

        public QueueablePMSCall(List<Id> oppId) {
            this.opp = [SELECT Id, Name, Account.Name, CloseDate, Amount, StageName
                        FROM Opportunity 
                        WHERE Id =: oppId[0] 
                        LIMIT 1];
        }

        public void execute(QueueableContext context) {
            JSONGenerator genBody = JSON.createGenerator(true);

            genBody.writeStartObject();
                genBody.writeStringField('opportunityId', opp.Id);
                genBody.writeStringField('opportunityName', opp.Name);
                genBody.writeStringField('accountName', opp.Account.Name);
                genBody.writeDateField('closeDate', opp.closeDate);
                genBody.writeNumberField('amount', opp.Amount);
            genBody.writeEndObject();

            String stringBody = genBody.getAsString();

            HttpRequest request = new HttpRequest();
                request.setEndpoint('callout:ProjectService');
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                request.setHeader('token', ServiceTokens__c.getAll().values().Token__c);
                request.setBody(stringBody);

            Http http = new Http();
            HttpResponse response = http.send(request);

            if(response.getStatusCode() == 201) {
                opp.StageName = 'Submitted Project';
                update opp;
            }
            else if(response.getStatusCode() == 500) {
                opp.StageName = 'Resubmit Project';
                update opp;
            }
        }
    }
}