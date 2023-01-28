@isTest
public class PokemonTest {
	@isTest
    static void setupPokemon() {
        Test.startTest();
            List<Pokemon__c> pokemonsList = new List<Pokemon__c>();
            for (Integer i=0;i<10;i++) {
                pokemonsList.add(new Pokemon__c(name='Pokemon '+i));
            }
            insert pokemonsList;
            
            Pokemons movi = new Pokemons();
            Id batchId = Database.executeBatch(movi);
        Test.stopTest();
        
        System.assertEquals(10, [select count() from Pokemon__c]);
    }
    
    //Batch tests
    @isTest
    static void fakeResponseRegistroUnicoPokemon(){
        SingleRequestMock fakeResponse = new SingleRequestMock(
            200, 'Complete',
			'{ "weight": 69, "height": 7, "id": 1, "name": "bulbasaur", "stats": [ { "base_stat": 45, "effort": 0, "stat": { "name": "hp", "url": "https://pokeapi.co/api/v2/stat/1/" } }, { "base_stat": 49, "effort": 0, "stat": { "name": "attack", "url": "https://pokeapi.co/api/v2/stat/2/" } }, { "base_stat": 49, "effort": 0, "stat": { "name": "defense", "url": "https://pokeapi.co/api/v2/stat/3/" } }, { "base_stat": 65, "effort": 1, "stat": { "name": "special-attack", "url": "https://pokeapi.co/api/v2/stat/4/" } }, { "base_stat": 65, "effort": 0, "stat": { "name": "special-defense", "url": "https://pokeapi.co/api/v2/stat/5/" } }, { "base_stat": 45, "effort": 0, "stat": { "name": "speed", "url": "https://pokeapi.co/api/v2/stat/6/" } } ] }',
			null);
        
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
            List<Pokemon__c> pokemonsList = new List<Pokemon__c>();
            for (Integer i=0;i<2;i++) {
                pokemonsList.add(new Pokemon__c(name='Pokemon '+i));
            }
            
            Pokemons habi = new Pokemons();
            Id batchId = Database.executeBatch(habi,1);
        Test.stopTest();
        
        Pokemon__c pokemonTest = [SELECT Id, Name, ExtId__c, Altura__c, Ataque__c, Defensa__c
                              	  FROM Pokemon__c 
                              	  LIMIT 1];
        
        System.assertEquals('Bulbasaur', pokemonTest.Name );
        System.assertEquals('1', pokemonTest.ExtId__c);
        System.assertEquals(7, pokemonTest.Altura__c);
        System.assertEquals(49, pokemonTest.Ataque__c);
        System.assertEquals(49, pokemonTest.Defensa__c);
    }
}