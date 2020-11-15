/*This is a generic class for formatting and handling HTTP request/response.*/
public with sharing class SYS_HTTPService {
    
    /*this method forms a HTTP request based on the provided information, sends the request and returns the response.
    @param: reqMethod - GET, POST etc.
    @param: reqEndpoint - the request endpoint URL or Named credential
    @param: reqHeader - the request header parameters, if any.
    @param: reqBody - the request body data to be sent.
    @return: The response object.
    */
    public static HTTPResponse makeHTTPCallout(String reqMethod, String reqEndpoint, Map<String,String> reqHeader, String reqBody) {
        HTTP http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setMethod(reqMethod);
        req.setEndpoint(reqEndpoint);
        for(String header: reqHeader.keySet()) {
            req.setHeader(header, reqHeader.get(header));
        }
        req.setBody(reqBody);
        return http.send(req);
    }
}