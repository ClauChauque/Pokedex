@isTest
private with sharing class HabilidadesTest {
    @isTest
    static void setup() {
        List<Habilidad__c> habilidadList = new List<Habilidad__c>();
        for (Integer i=0;i<10;i++) {
            habilidadList.add(new Habilidad__c(name='Habilidad '+i));
        }
        insert habilidadList;
        Test.startTest();
        Habilidades habi = new Habilidades();
        Id batchId = Database.executeBatch(habi);
        Test.stopTest();
        System.assertEquals(10, [select count() from Habilidad__c]);
    }
    
    //Batch tests
    @isTest
    static void fakeResponseRegistroUnico(){
        SingleRequestMock fakeResponse = new SingleRequestMock(
            200, 'Complete',
			'{"effect_entries": [ { "short_effect": "Has a 10% chance of making target Pokémon flinch with each hit." } ], "id": 1, "name": "stench"}',
			null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
        List<Integer> num = new List<Integer>();
        for(Integer i = 1 ; i <= 1; i++){
            num.add(i);
        }
        
        Habilidades habi = new Habilidades();
        Id batchId = Database.executeBatch(habi,1);
        Test.stopTest();
        
        Habilidad__c habilidadTest = [SELECT Id, Name, ExtId__c, Efecto__c 
                              FROM Habilidad__c 
                              LIMIT 1];
        
        System.assertEquals('Stench', habilidadTest.Name );
        System.assertEquals('1', habilidadTest.ExtId__c);
        System.assertEquals('Has a 10% chance of making target Pokémon flinch with each hit.', habilidadTest.Efecto__c);
    }
}