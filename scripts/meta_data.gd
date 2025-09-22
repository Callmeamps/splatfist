class_name MetaData
extends Resource

@export_group("Character Details")
@export var name: String = "Sylvester Jones"    # CON: resistance to status/knockback
@export var species: String = "Cthulu"      # VIT: HP pool
@export var character_data: CharacterData


@export_group("Combat Details")
@export var styles: String = "Squid-Fu"
@export var archetype: String = "Bruiser"
@export var weapons: String = "None" 

@export_group("Display Details")
@export var portrait: String
