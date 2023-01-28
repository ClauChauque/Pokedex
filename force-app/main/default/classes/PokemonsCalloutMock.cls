@isTest
public with sharing class PokemonsCalloutMock {
    public HttpResponse respond() {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{}');
        response.setStatusCode(200);
        return response; 
    }
}