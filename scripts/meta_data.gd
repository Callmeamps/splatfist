class_name MetaData
extends Resource

@export_group("Character Details")
@export var name: String = "Sylvester"    # CON: resistance to status/knockback
@export var species: String = "Cthulu"      # VIT: HP pool
@export var weapons: String = "None" # END: multiplier for stamina cost/regen

@export_group("Combat Details")
@export var styles: float = 180.0
@export var archetype: float = 90.0
@export var dash_speed: float = 420.0
@export var run_speed: float = 320.0
@export var ground_acceleration: float = 3000.0
@export var dash_time: float = 0.14