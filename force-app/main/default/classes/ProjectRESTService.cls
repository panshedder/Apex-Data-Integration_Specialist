global class ProjectRESTService {
    //Implement service logic here
    global void postProjectData() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('callout:ProjectService');
        request.setMethod('POST');

        HttpResponse response = http.send(request);

        System.debug('Resp: ' + response);
    }
}