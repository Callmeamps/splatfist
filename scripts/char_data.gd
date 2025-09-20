# CharacterData.gd
# --- UPDATED ---
# Added new variables for more detailed movement and defensive costs.

class_name CharacterData
extends Resource

@export_group("Core Stats (RPG)")
@export var constitution: int = 100    # CON: resistance to status/knockback
@export var vitality: int = 1000      # VIT: HP pool
@export var endurance_mult: float = 1.0 # END: multiplier for stamina cost/regen
@export var strength: int = 100       # STR: raw damage scaling
@export var agility: int = 100        # AGI: air control, recovery, mobility
@export var speed: int = 100          # SPD: affects run/walk/dash speeds

@export_group("Movement - Ground")
@export var walk_speed: float = 180.0
@export var crouch_walk_speed: float = 90.0
@export var dash_speed: float = 420.0
@export var run_speed: float = 320.0
@export var ground_acceleration: float = 3000.0
@export var dash_time: float = 0.14

@export_group("Movement - Air")
@export var gravity: float = 1800.0
@export var max_fall_speed: float = 2500.0
@export var jump_velocity: float = -620.0
@export var double_jump_velocity: float = -520.0
@export var air_acceleration: float = 1400.0
@export var air_dash_speed: float = 480.0
@export var max_jumps: int = 2
@export var max_air_dashes: int = 1

@export_group("Resources")
@export var max_stamina: float = 100.0
@export var stamina_regen_rate: float = 6.0
@export var stamina_regen_delay: float = 1.0
@export var max_mana_bars: int = 2
@export var mana_per_bar: int = 100

@export_group("Combat & Defense")
@export var dodge_invuln_time: float = 0.18
@export var dodge_stamina_cost: float = 18.0
@export var block_stamina_cost_per_hit: float = 12.0
@export var light_dmg: int = 40
@export var mid_dmg: int = 80
@export var bash_dmg: int = 140 # Heavy Bash
@export var launcher_dmg: int = 160 # Launcher
# Scene for the hitbox that attacks will spawn
@export var hitbox_scene: PackedScene

@export_group("Make System")
@export var make_scene: PackedScene # e.g., a platform scene
@export var make_cost: int = 25
@export var super_make_cost: int = 100
@export var make_cooldown: float = 0.8
