public with sharing class Habilidades implements Database.Batchable<Integer>, Database.AllowsCallouts{

    //BATCH para insertar habilidades
    public List<Integer> start(Database.BatchableContext bc) {
        List<integer> listIterable = new List<integer>();
        for(integer i=1; i<=267; i++){
            listIterable.add(i);
        }
        return listIterable;
    }
    
    public void execute(Database.BatchableContext bc, List<integer> records){
        HttpResponse response = HttpCalloutPokeApi.obtenerDatosDePokeAPI('ability', records[0]);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        String abilityName = (String) results.get('name');

        //string abilityID = (string) results.get('id');

        List<object> effectEntries = (List<object>) results.get('effect_entries');
        string abilityEffect;
        if(effectEntries.size()>2){
            map<string, object> effectEngl = (map<string, object>) effectEntries.get(1);
        	abilityEffect = (string) effectEngl.get('short_effect');
        }else if(effectEntries.size()>0){
            map<string, object> effectEngl = (map<string, object>) effectEntries.get(0);
        	abilityEffect = (string) effectEngl.get('short_effect');
        }else{
            abilityEffect = null;
        }

        //Primera letra mayúscula
        abilityName = abilityName.capitalize();
        
        //Creo y guardo cada objeto habilidad
        Habilidad__c habilidad = new Habilidad__c(
            Name = abilityName,
            Efecto__c = abilityEffect);

        //Llamada a la API
    	insert habilidad;
    }
        
    public void finish(Database.BatchableContext bc){
        System.debug('Habilidades insertadas');
	}
}