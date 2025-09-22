# walk_state.gd
extends PlayerState

var input_axis: int

func enter():
	player.sprite.play("walk")

func process_physics(delta: float):
	if not player.is_on_floor():
		state_machine.set_state("Fall")
		return
		
	input_axis = Input.get_axis("move_left", "move_right")
	
	# Use walk speed for controlled movement
	var target_speed = input_axis * player.character_data.walk_speed
	player.velocity.x = lerp(player.velocity.x, target_speed, player.character_data.ground_acceleration * delta * 0.5) # Slower accel
	
	# Transitions
	if input_axis == 0:
		state_machine.set_state("Idle")
	if not Input.is_action_pressed("mod") and input_axis != 0:
		state_machine.set_state("Run")
	elif Input.is_action_just_pressed("jump"):
		state_machine.set_state("Jump")
	elif Input.is_action_pressed("crouch"):
		state_machine.set_state("Crouch")

func process_input(event: InputEvent) -> void:
# Transitions
	if event.is_action_just_pressed("move_right"):
		state_machine._check_for_dash(1)
	elif event.is_action_just_pressed("move_left"):
		state_machine._check_for_dash(-1)
