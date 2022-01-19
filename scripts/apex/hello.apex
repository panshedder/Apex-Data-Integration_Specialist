HttpRequest req = new HttpRequest();
req.setEndpoint('callout:ProjectService');
req.setMethod('GET');

Http http = new Http();

HttpResponse res = http.send(req);

System.debug('Res: ' + res.getBody());