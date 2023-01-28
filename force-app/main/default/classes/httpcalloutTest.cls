@isTest
public class httpcalloutTest {
	@isTest
    private static void httpcalloutTestMovimientos() {
        Test.setMock(HttpCalloutMock.class, new MovimientoCalloutMock());
        
        HttpResponse result = HttpCalloutPokeApi.obtenerDatosDePokeAPI('move',1);
        // Verify mock response is not null
        System.assertNotEquals(null,result, 'The callout returned a null response.');
        // Verify status code
        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');
        // Verify content type   
        System.assertEquals('application/json', result.getHeader('Content-Type'),'The content type value is not expected.');  
        // Verify the data in the calloutmock
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(result.getBody());
        
        String name = (String) results.get('name');
        system.assertEquals('pound', name);

        Integer idNum = (integer) results.get('id');
        system.assertEquals(1, idNum);
	}
    
    @isTest
    private static void httpcalloutTestHabilidad() {
        Test.setMock(HttpCalloutMock.class, new HabilidadCalloutMock());
        
        HttpResponse result = HttpCalloutPokeApi.obtenerDatosDePokeAPI('ability',1);
        // Verify mock response is not null
        System.assertNotEquals(null,result, 'The callout returned a null response.');
        // Verify status code
        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');
        // Verify content type   
        System.assertEquals('application/json', result.getHeader('Content-Type'),'The content type value is not expected.');  
        // Verify the data in the calloutmock
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(result.getBody());
        
        String name = (String) results.get('name');
        system.assertEquals('stench', name);

        Integer idNum = (integer) results.get('id');
        system.assertEquals(1, idNum);

        List<object> effectEntries = (List<object>) results.get('effect_entries');
        map<string, object> effectEngl = (map<string, object>) effectEntries.get(0);
        string abilityEffect = (string) effectEngl.get('short_effect');
        System.assertEquals('Has a 10% chance of making target Pokémon flinch with each hit.', abilityEffect); 
    }
    
}