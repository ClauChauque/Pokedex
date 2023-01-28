import { LightningElement, api, wire } from 'lwc';
import getPokemonsFiltradosTipo from '@salesforce/apex/PokemonController.getPokemonsFiltradosTipo';
import NAME_FIELD from '@salesforce/schema/Pokemon__c.Name';
import Defensa__c_FIELD from '@salesforce/schema/Pokemon__c.Defensa__c';
import ExtId__c_FIELD from '@salesforce/schema/Pokemon__c.ExtId__c';
import Generacion__c_FIELD from '@salesforce/schema/Pokemon__c.Generacion__c';
import Habilidad__c_FIELD from '@salesforce/schema/Pokemon__c.Habilidad__r.Name';
import Imagen__c_FIELD from '@salesforce/schema/Pokemon__c.Imagen__c';
import Peso__c_FIELD from '@salesforce/schema/Pokemon__c.Peso__c';
import Tipos__c_FIELD from '@salesforce/schema/Pokemon__c.Tipos__c'
import Velocidad__c_FIELD from '@salesforce/schema/Pokemon__c.Ataque__c';
import Vida__c_FIELD from '@salesforce/schema/Pokemon__c.Vida__c';
import getPokemons from '@salesforce/apex/PokemonController.getPokemons';


//DATOS PARA TABLA
const COLUMNS = [
    { label: 'Pokemon Name', fieldName: NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Imagen', fieldName: Imagen__c_FIELD.fieldApiName, type: 'url' },
    { label: 'Generacion', fieldName: Generacion__c_FIELD.fieldApiName, type: 'number' },
    { label: 'Tipos', fieldName: Tipos__c_FIELD.fieldApiName, type: 'number' },
    { label: 'id', fieldName: ExtId__c_FIELD.fieldApiName, type: 'number' },
    { label: 'Vida', fieldName: Vida__c_FIELD.fieldApiName, type: 'number' },
    { label: 'Defensa', fieldName: Defensa__c_FIELD.fieldApiName, type: 'number' },
    { label: 'Habilidad', fieldName: Habilidad__c_FIELD.fieldApiName, type: 'text' },
    { label: 'Peso', fieldName: Peso__c_FIELD.fieldApiName, type: 'number' },
    { label: 'Velocidad', fieldName: Velocidad__c_FIELD.fieldApiName, type: 'number' },
];


export default class Filtros extends LightningElement {
    //DATOS PARA TABLA
    columns = COLUMNS;
    @wire(getPokemons)
    pokemons;

    //FILTRO TIPO
    _selected = [];
    @api tipoPokemon;
    @wire(getPokemonsFiltradosTipo, {tipo: '$tipoPokemon'})
    tipos

    get options() {
        return [
            { label: 'Normal', value: 'normal' },
            { label: 'Fighting', value: 'fighting' },
            { label: 'Flying', value: 'flying' },
            { label: 'Poison', value: 'poison' },
            { label: 'Ground', value: 'ground' },
            { label: 'Rock', value: 'rock' },
            { label: 'Bug', value: 'bug' },
            { label: 'Ghost', value: 'ghost' },
            { label: 'Steel', value: 'steel' },
            { label: 'Fire', value: 'fire' },
            { label: 'Water', value: 'wter' },
            { label: 'Grass', value: 'grass' },
            { label: 'Electric', value: 'electric' },
            { label: 'Psychic', value: 'psychic' },
            { label: 'Ice', value: 'ice' },
            { label: 'Dragon', value: 'dragon' },
            { label: 'Dark', value: 'dark' },
            { label: 'Fairy', value: 'fairy' },
            { label: 'Unknown', value: 'unknown' },
            { label: 'Shadow', value: 'shadow' },
        ];
    }

    get selected() {
        return this._selected.length ? this._selected : 'none';
    }

    handleChange(e) {
        this._selected = e.detail.value;
    }

    //FILTRO GENERACIÓN
    generacionOptions = [
        { label: 'Todas', value: ''},
            { label: 'Generación 1', value: '1' },
            { label: 'Generación 2', value: '2' },
            { label: 'Generación 3', value: '3' },
            { label: 'Generación 4', value: '4' },
            { label: 'Generación 5', value: '5' },
            { label: 'Generación 6', value: '6' },
            { label: 'Generación 7', value: '7' },
            { label: 'Generación 8', value: '8' }
    ]

    handleFiltrarPorGeneracion(event){
        this.generacion = event.target.value
    }

    //FILTRO BUSCADOR
    queryTerm;

    handleKeyUp(evt) {
        const isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            this.queryTerm = evt.target.value;
        }
    }

}