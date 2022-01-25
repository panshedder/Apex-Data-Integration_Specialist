global class BillingCalloutServiceMock implements WebServiceMock {
   //Implement http mock callout here
   global void doInvoke(
      Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

      BillingServiceProxy.billProjectResponse_element response_x = new BillingServiceProxy.billProjectResponse_element();
      response_x.status = 'Ok';

      response.put('response_x', response_x);
   }
}