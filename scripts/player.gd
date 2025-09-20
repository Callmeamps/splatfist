# player.gd
# This script has been refactored to work with the CharacterData resource and the
# state machine. It holds the current state (HP, velocity, etc.) and provides
# methods for states to call, but the complex logic is now in the state scripts.

class_name Player
extends CharacterBody2D

# --- Signals ---
signal hp_changed(current_hp, max_hp)
signal stamina_changed(current_stamina, max_stamina)
signal moya_changed(current_moya, max_moya)
signal player_knocked_out(player)

# --- Exports ---
@export var character_data: CharacterData
@export var meta_data: MetaData

# --- Nodes ---
@onready var state_machine: StateMachine = $StateMachine
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var make_spawn_point: Marker2D = $MakeSpawnPoint
@onready var hitboxes_node: Node2D = $hitbox
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# --- State Variables ---
var current_hp: int
var current_stamina: float
var current_moya: int
var jumps_left: int
var air_dashes_left: int
var facing_direction: int = 1 # 1 for right, -1 for left

# Timers
var stamina_regen_timer: float = 0.0
var make_cooldown_timer: float = 0.0

# --- Godot Functions ---
var default_collider_height: float

func _ready() -> void:
	if not character_data:
		push_error("Player scene is missing its CharacterData resource!")
		return
	
	# Store the initial height of the collision shape.
	if collision_shape and collision_shape.shape is CapsuleShape2D:
		default_collider_height = collision_shape.shape.height
	elif collision_shape and collision_shape.shape is RectangleShape2D:
		default_collider_height = collision_shape.shape.size.y
	
	if not character_data:
		push_error("Player scene is missing its CharacterData resource!")
		return
	
	# Initialize stats from the data object
	current_hp = character_data.vitality
	current_stamina = character_data.max_stamina
	jumps_left = character_data.max_jumps
	air_dashes_left = character_data.max_air_dashes
	
	state_machine.init(self)
	
	emit_signal("hp_changed", current_hp, character_data.vitality)
	emit_signal("stamina_changed", current_stamina, character_data.max_stamina)
	emit_signal("moya_changed", current_moya, character_data.mana_per_bar * character_data.max_mana_bars)


func _physics_process(delta: float) -> void:
	# Handle persistent timers
	_handle_timers(delta)
	
	# Delegate logic to the current state
	state_machine.process_physics(delta)
	
	# Update sprite direction
	if sprite:
		sprite.flip_h = (facing_direction < 0)
	
	move_and_slide()
	
	# Reset jumps and air dashes when landed
	if is_on_floor():
		jumps_left = character_data.max_jumps
		air_dashes_left = character_data.max_air_dashes

# --- Private Methods ---
func _handle_timers(delta: float) -> void:
	# Stamina Regeneration
	if stamina_regen_timer > 0:
		stamina_regen_timer -= delta
	else:
		if current_stamina < character_data.max_stamina:
			var new_stamina = current_stamina + character_data.stamina_regen_rate * delta
			current_stamina = min(new_stamina, character_data.max_stamina)
			emit_signal("stamina_changed", current_stamina, character_data.max_stamina)
			
	# Make Cooldown
	if make_cooldown_timer > 0:
		make_cooldown_timer = max(0, make_cooldown_timer - delta)

# --- Public API for States ---
func set_facing_direction(direction: int):
	if direction != 0:
		facing_direction = direction

func spend_stamina(amount: float) -> bool:
	amount *= character_data.endurance_mult
	if current_stamina >= amount:
		current_stamina -= amount
		stamina_regen_timer = character_data.stamina_regen_delay
		emit_signal("stamina_changed", current_stamina, character_data.max_stamina)
		return true
	
	# TODO: Guard Break State
	print("Stamina broken!")
	return false

func spend_moya(amount: int) -> bool:
	if current_moya >= amount:
		current_moya -= amount
		emit_signal("moya_changed", current_moya, character_data.mana_per_bar * character_data.max_mana_bars)
		return true
	return false

func gain_moya(amount: int):
	var max_moya = character_data.mana_per_bar * character_data.max_mana_bars
	current_moya = clamp(current_moya + amount, 0, max_moya)
	emit_signal("moya_changed", current_moya, max_moya)

func perform_make(is_super: bool = false):
	if make_cooldown_timer > 0: return
	
	var cost = character_data.super_make_cost if is_super else character_data.make_cost
	if spend_moya(cost):
		if not character_data.make_scene: return
		
		var make_instance = character_data.make_scene.instantiate()
		var spawn_pos = make_spawn_point.global_position
		make_instance.global_position = spawn_pos
		get_parent().add_child(make_instance) # Add to main scene tree
		make_cooldown_timer = character_data.make_cooldown

func take_damage(damage: int, knockback: Vector2 = Vector2.ZERO):
	current_hp = max(0, current_hp - damage)
	velocity = knockback
	gain_moya(damage) # Gain mana when taking damage
	emit_signal("hp_changed", current_hp, character_data.vitality)
	
	# TODO: Transition to a "Hitstun" state
	
	if current_hp <= 0:
		emit_signal("player_knocked_out", self)
		# TODO: Transition to a "KnockedOut" state

func set_crouching(is_crouching: bool):
	if not collision_shape: return
	
	var shape = collision_shape.shape
	var target_height = default_collider_height * 0.6 if is_crouching else default_collider_height
	
	if shape is CapsuleShape2D:
		shape.height = target_height
	elif shape is RectangleShape2D:
		var new_size = shape.size
		new_size.y = target_height
		shape.size = new_size
	
	# Move the collider down so the player's feet stay on the ground
	var offset = (default_collider_height - target_height) / 2
	collision_shape.position.y = offset

func on_grab_success(opponent: Player):
	print(name + " successfully grabbed " + opponent.name)
	
	# Check if the opponent is another player with the required functions.
	if opponent.has_method("get_grabbed_by") and opponent.has_method("take_damage"):
		# 1. Force the opponent into the "Grabbed" state.
		opponent.get_grabbed_by(self)
		
		# 2. Apply the grab damage from our CharData.
		opponent.take_damage(character_data.grab_dmg)


# This function is called by an attacker to force this player into the Grabbed state.
func get_grabbed_by(attacker: Player):
	# Immediately transition our own state machine into the Grabbed state.
	state_machine.transition_to("Grabbed")
	
	# We can also use this moment to make sure we are positioned correctly
	# relative to the attacker, for example, right in front of them.
	var direction = 1 if attacker.sprite.is_flipped_h() else -1
	global_position.x = attacker.global_position.x - (60 * direction) # Match the grabbox offset
