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

func process_physics(delta: float) -> void:
	if current_state and current_state.has_method("process_physics"):
		current_state.process_physics(delta)

func process_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("process_input"):
		current_state.process_input(event)

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
