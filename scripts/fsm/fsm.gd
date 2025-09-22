# state_machine.gd
# This script is now a pure manager. It finds its child nodes, assumes they are
# states with the correct functions, and handles the transitions between them.
# I've added a base "PlayerState" class that all your other states should extend.

class_name StateMachine
extends Node

# This will be the base class for all of your state scripts.
# Save this class in its own file, e.g., "res://player/player_state.gd"
# class_name PlayerState
# extends Node
# 
# var player: Player
# var state_machine: StateMachine
# 
# func init(_player: Player, _state_machine: StateMachine):
# 	self.player = _player
# 	self.state_machine = _state_machine
# 
# func enter(): pass
# func exit(): pass
# func process_input(event: InputEvent): pass
# func process_physics(delta: float): pass


var player: Player
var current_state: Node
var states: Dictionary = {}
var last_tap_dir: int = 0
@onready var dash_timer: Timer = $DashTimer

func _ready() -> void:
	for child in get_children():
		states[child.name.to_lower()] = child

func init(parent_player: Player) -> void:
	self.player = parent_player
	for state_name in states:
		# Check if the state node has the required 'init' method.
		if states[state_name].has_method("init"):
			states[state_name].init(player, self)
	
	set_state("Idle")

func process_input(event: InputEvent) -> void:
	# Call process_input on the current state
	if current_state and current_state.has_method("process_input"):
		current_state.process_input(event)
	
	# --- Add this global dash check ---
	# Check for dash regardless of the current state (as long as it's a ground state)
	if current_state.name.to_lower() in ["idle", "walk", "run"]:
		if event.is_action_just_pressed("move_right"):
			_check_for_dash(1)
		elif event.is_action_just_pressed("move_left"):
			_check_for_dash(-1)

func process_physics(delta: float) -> void:
	if current_state and current_state.has_method("process_physics"):
		current_state.process_physics(delta)



func set_state(state_name: String) -> void:
	state_name = state_name.to_lower()
	if not states.has(state_name):
		push_error("State '%s' does not exist!" % state_name)
		return

	if current_state and current_state.has_method("exit"):
		current_state.exit()
	
	current_state = states[state_name]
	
	if current_state.has_method("enter"):
		current_state.enter()

func get_state(state_name: String) -> Node:
	state_name = state_name.to_lower()
	if states.has(state_name):
		return states[state_name]
	else:
		push_error("State '%s' does not exist!" % state_name)
		return

func _check_for_dash(tap_dir: int):
	# If the timer is running and the tap is in the same direction...
	if not dash_timer.is_stopped() and tap_dir == last_tap_dir:
		# It's a successful double-tap!
		set_state("Dash")
		# Stop the timer and reset the direction.
		dash_timer.stop()
		last_tap_dir = 0
	else:
		# This is the first tap. Start the timer and record the direction.
		dash_timer.start(0.25) # 250ms window
		last_tap_dir = tap_dir

# This function is connected to the Timer's timeout signal.
func _on_dash_timer_timeout():
	# The player didn't tap a second time fast enough. Reset the direction.
	last_tap_dir = 0
