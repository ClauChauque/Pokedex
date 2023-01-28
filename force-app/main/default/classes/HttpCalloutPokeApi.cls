public with sharing class HttpCalloutPokeApi {
    public static HttpResponse obtenerDatosDePokeAPI(string datoAExtraer, integer n) {
        Http http = new Http();
        httpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/'+datoAExtraer+'/'+n);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        Map<String, Object> results = new Map<String, Object>();

        if(response.getStatusCode() == 200) {
            results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        }
        
        return response;
    }
}