# player_state.gd
class_name PlayerState
extends Node

var player: Player
var state_machine: StateMachine

# This function is called by the StateMachine to give the state references.
func init(_player: Player, _state_machine: StateMachine):
	self.player = _player
	self.state_machine = _state_machine

# Runs once when the state is entered.
func enter():
	pass

# Runs once when the state is exited.
func exit():
	pass

# Runs on every user input event.
func process_input(event: InputEvent):
	pass

# Runs every physics frame. Main logic goes here.
func process_physics(delta: float):
	pass
