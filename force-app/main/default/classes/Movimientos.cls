public class Movimientos implements Database.Batchable<Integer>, Database.AllowsCallouts{
    //BATCH para insertar habilidades
    public List<Integer> start(Database.BatchableContext bc) {
        List<integer> listIterable = new List<integer>();
        for(integer i=1; i<=826; i++){
            listIterable.add(i);
        }
        return listIterable;
    }
    
    public void execute(Database.BatchableContext bc, List<integer> records){

        HttpResponse response = HttpCalloutPokeApi.obtenerDatosDePokeAPI('move', records[0]);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        //Desarmando para llegar a short_effect
        List<object> effectEntries = (List<object>) results.get('effect_entries');
        string moveEffect;
        if(effectEntries.size() > 0){
            map<string, object> effectEngl = (map<string, object>) effectEntries.get(0);
		    moveEffect = (string) effectEngl.get('short_effect');
        }else{
            moveEffect = null;
        }
				
        map<string, object> target = (map<string, object>) results.get('target');
        map<string, object> type = (map<string, object>) results.get('type');
        
        integer moveAcurrancy = (integer) results.get('accuracy');
        integer moveEffectChance = (integer) results.get('effect_chance');
        string moveTargetName = (string) target.get('name');
        integer movePriority = (integer) results.get('priority');
        string moveName = (string) results.get('name');
        integer moveID = (integer) results.get('id');
        integer movePower = (integer) results.get('power');
        integer movePP = (integer) results.get('pp');
        string moveTypeName = (string) type.get('name');
        
        //Primera letra mayúscula
        moveName = moveName.capitalize();
        
        //Creo y guardo cada objeto Movimiento
        Movimiento__c movimiento = new Movimiento__c(
            Name = moveName,
            ChanceDeEfecto__c = moveEffectChance,
            Punteria__c=moveAcurrancy,
            Objetivo__c = moveTargetName,
            Prioridad__c = movePriority,
            Efecto__c = moveEffect,
            Poder__c = movePower,
            PuntosDePoder__c = movePP,
            Tipo__c = moveTypeName);
        
        
        insert movimiento;
    }
        
    public void finish(Database.BatchableContext bc){
        System.debug('Movimientos insertados');
	}
}