@isTest
public class MovimientosTest {
   @isTest
    static void setupMovimiento() {
        List<Movimiento__c> movimientosList = new List<Movimiento__c>();
        for (Integer i=0;i<10;i++) {
            movimientosList.add(new Movimiento__c(name='Movimiento '+i));
        }
        insert movimientosList;
        Test.startTest();
        Movimientos movi = new Movimientos();
        Id batchId = Database.executeBatch(movi);
        Test.stopTest();
        System.assertEquals(10, [select count() from Movimiento__c]);
    }
    
    //Batch tests
    @isTest
    static void fakeResponseRegistroUnicoMovimiento(){
        SingleRequestMock fakeResponse = new SingleRequestMock(
            200, 'Complete',
			'{ "accuracy": 100, "effect_chance": null, "effect_entries": [ { "effect": "Inflicts regular damage.", "language": { "name": "en", "url": "https://pokeapi.co/api/v2/language/9/" }, "short_effect": "Inflicts regular damage with no additional effect." } ], "id": 1, "name": "pound", "power": 40, "pp": 35, "priority": 0, "target": { "name": "selected-pokemon", "url": "https://pokeapi.co/api/v2/move-target/10/" }, "type": { "name": "normal", "url": "https://pokeapi.co/api/v2/type/1/" } }',
			null);
        
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        List<Movimiento__c> movimientosList = new List<Movimiento__c>();
        for (Integer i=0;i<2;i++) {
            movimientosList.add(new Movimiento__c(name='Movimiento '+i));
        }
        
        Test.startTest();
        Habilidades habi = new Habilidades();
        Id batchId = Database.executeBatch(habi,1);
        Test.stopTest();
        
        Movimiento__c movimientoTest = [SELECT Id, Name, ExtId__c, Efecto__c 
                              			FROM Movimiento__c 
                              			LIMIT 1];
        
        System.assertEquals('Pound', movimientoTest.Name );
        System.assertEquals('1', movimientoTest.ExtId__c);
        System.assertEquals('Inflicts regular damage with no additional effect.', movimientoTest.Efecto__c);
    }
}