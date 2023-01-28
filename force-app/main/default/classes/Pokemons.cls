public class Pokemons implements Database.Batchable<Integer>, Database.AllowsCallouts{
	public List<Integer> start(Database.BatchableContext bc) {
        List<integer> listIterable = new List<integer>();
        for(integer i=1; i<=898; i++){
            listIterable.add(i);
        }
        return listIterable;
    }
    
    public void execute(Database.BatchableContext bc, List<integer> records){

        HttpResponse response = HttpCalloutPokeApi.obtenerDatosDePokeAPI('pokemon', records[0]);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        //Lista "Tipo de pókemon"
        List<object> types = (List<object>) results.get('types');
        list<string> typeNameList = new List<string>();

        for(integer i=0; i<types.size(); i++){
            map<string, object> typeNumberI = (map<string, object>) types.get(i);
            map<string, object> type = (map<string, object>) typeNumberI.get('type');
            string typeName = (string) type.get('name');

            typeNameList.add(typeName);
        }
        //Asumiendo que los pókemons pueden ser solo de 2 tipos
        string typeNames;
        if(typeNameList.size()>=2){
            typeNames = typeNameList[0] + ';' + typeNameList[1];
        }else{
            typeNames = typeNameList[0];
        }

        //Vidas "stats - base_stat"
        List<Object> stats = (List<Object>) results.get('stats');
        map<string, object> hp = (map<string, object>) stats.get(0);
        //Velocidad "stats-speed"
        map<string, object> speed = (map<string, object>) stats.get(5);
        //Defensa stats-defense
        map<string, object> defense = (map<string, object>) stats.get(2);
        //Ataque stats-attack
        map<string, object> attack = (map<string, object>) stats.get(1);


        //Img sprite  -  Front_Default
        map<string, object> sprite = (map<string, object>) results.get('sprites');


        //Campos a llenar
        //string pokemonID = (string) results.get('id');
        integer pokemonAltura = (integer) results.get('height');
        integer pokemonPeso = (integer) results.get('weight');
        string pokemonName = (string) results.get('name');
        integer pokemonHP = (integer) hp.get('base_stat');
        integer pokemonVelocidad = (Integer) speed.get('base_stat');
        integer pokemonDefensa = (integer) defense.get('base_stat');
        integer pokemonAtaque = (integer) attack.get('base_stat');
        string pokemonFrontDefoultIMG = (string) sprite.get('front_default');

        //Primera letra mayúscula
        pokemonName = pokemonName.capitalize();


        //Campo HABILIDAD
        List<object> abilities = (List<object>) results.get('abilities');
        map<string, object> abilityNumber = (map<string, object>) abilities.get(0);
        map<string, object> ability = (map<string, object>) abilityNumber.get('ability');
        string abilityName = (string) ability.get('name');

        List<Habilidad__c> newIDHabilidad = [SELECT Name FROM Habilidad__c WHERE Name = :abilityName];
        id idHabilidad;
        if(newIDHabilidad.size() > 0){
            Habilidad__c habilidad = newIDHabilidad[0];
            idHabilidad = (id) habilidad.id;
        }


        //Campos MOVIMIENTOS (slot 1, 2, 3 y 4)
        List<object> moves = (List<object>) results.get('moves');
        list<string> movesList = new List<string>();

        //si la lista moves tiene 4 o más movimientos...
        if(moves.size()>=4){
            for(integer i=0; i<4; i++){
                //Numero random
                map<string, object> movesNumber = (map<string, object>) moves.get(i);
                map<string, object> move = (map<string, object>) movesNumber.get('move');
                string moveName = (string) move.get('name');
    
                movesList.add(moveName);
            }
        }else if(moves.size()>0 && moves.size()<4){
            for(integer i=0; i<moves.size(); i++){
                map<string, object> movesNumber = (map<string, object>) moves.get(i);
                map<string, object> move = (map<string, object>) movesNumber.get('move');
                string moveName = (string) move.get('name');
    
                movesList.add(moveName);
            }
        }else{
            movesList = null;
        }
        
        List<Movimiento__c> newIDMovimiento = new List<Movimiento__c>();
        if(movesList.size()==4){
            for(integer i=0; i<4; i++){
                newIDMovimiento.add([SELECT Name FROM Movimiento__c WHERE Name = :movesList[i]]);
            }
        } else if(movesList.size()<4 && movesList.size()>0){
            for(integer i=0; i<movesList.size(); i++){
                newIDMovimiento.add([SELECT Name FROM Movimiento__c WHERE Name = :movesList[i]]);
            }
        }else {
            newIDMovimiento = null;
        }
        
        id pokemonSlot1 = null;
        id pokemonSlot2 = null;
        id pokemonSlot3 = null;
        id pokemonSlot4 = null;

        if(newIDMovimiento.size() >= 4){
            Movimiento__c movimiento1 = newIDMovimiento[0];
            pokemonSlot1 = movimiento1.id;

            Movimiento__c movimiento2 = newIDMovimiento[1];
            pokemonSlot2 = movimiento2.id;

            Movimiento__c movimiento3 = newIDMovimiento[2];
            pokemonSlot3 = movimiento3.id;

            Movimiento__c movimiento4 = newIDMovimiento[3];
            pokemonSlot4 = movimiento4.id;

        }else if(newIDMovimiento.size()== 3){
            Movimiento__c movimiento1 = newIDMovimiento[0];
            pokemonSlot1 = movimiento1.id;

            Movimiento__c movimiento2 = newIDMovimiento[1];
            pokemonSlot2 = movimiento2.id;

            Movimiento__c movimiento3 = newIDMovimiento[2];
            pokemonSlot3 = movimiento3.id;

        }else if(newIDMovimiento.size()== 2){
            Movimiento__c movimiento1 = newIDMovimiento[0];
            pokemonSlot1 = movimiento1.id;

            Movimiento__c movimiento2 = newIDMovimiento[1];
            pokemonSlot2 = movimiento2.id;

        }else if(newIDMovimiento.size()== 1){
            Movimiento__c movimiento1 = newIDMovimiento[0];
            pokemonSlot1 = movimiento1.id;
        }
        
        //Primera letra mayúscula
        pokemonName = pokemonName.capitalize();
        
        //Creo y guardo cada objeto pokemon
        Pokemon__c pokemon = new Pokemon__c(
        	Name = pokemonName,
            Altura__c = pokemonAltura,
            Habilidad__c = idHabilidad,
            Peso__c = pokemonPeso,
            Tipos__c = typeNames,
            Vida__c = pokemonHP,
            Velocidad__c = pokemonVelocidad,
            Defensa__c = pokemonDefensa,
            Ataque__c = pokemonAtaque,
            Slot1__c = pokemonSlot1,
            Slot2__c = pokemonSlot2,
            Slot3__c = pokemonSlot3,
            Slot4__c = pokemonSlot4,
            Imagen__c = pokemonFrontDefoultIMG
        );

        insert pokemon;
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('Pokemons insertados');
	}
}