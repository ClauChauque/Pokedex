public with sharing class PokemonController {
    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> getPokemons() {
        return [
            SELECT Name, Defensa__c, ExtId__c, Generacion__c, Imagen__c, Peso__c, Tipos__c, Velocidad__c, Vida__c, Habilidad__r.Name
            FROM Pokemon__c
            WITH SECURITY_ENFORCED
            ORDER BY id
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> getPokemonsFiltradosTipo(string tipo) {
        return [
            SELECT Name, Altura__c, Ataque__c
            FROM Pokemon__c
            WHERE Tipos__c = :tipo
            WITH SECURITY_ENFORCED
            ORDER BY id
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> getTipos() {
        return [
            SELECT Tipos__c
            FROM Pokemon__c
            WITH SECURITY_ENFORCED
            ORDER BY id
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> getPokemonsFiltradosGeneracion(integer generacion) {
        return [
            SELECT Tipos__c
            FROM Pokemon__c
            WHERE Generacion__c = :generacion
            WITH SECURITY_ENFORCED
            ORDER BY id
        ];
    }
}