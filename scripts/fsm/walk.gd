# walk_state.gd
extends PlayerState

func enter():
	player.sprite.play("walk")

func process_physics(delta: float):
	if not player.is_on_floor():
		state_machine.set_state("Fall")
		return
		
	var input_axis = Input.get_axis("move_left", "move_right")
	
	# Use walk speed for controlled movement
	var target_speed = input_axis * player.character_data.walk_speed
	player.velocity.x = lerp(player.velocity.x, target_speed, player.character_data.ground_acceleration * delta * 0.5) # Slower accel
	player.set_facing_direction(input_axis)
	
	# Transitions
	if is_zero_approx(input_axis):
		state_machine.set_state("Idle")
	elif Input.is_action_pressed("run"): # Assuming a dedicated Run button/modifier
		state_machine.set_state("Run")
	elif Input.is_action_just_pressed("jump"):
		state_machine.set_state("Jump")
	elif Input.is_action_pressed("move_down"):
		state_machine.set_state("Crouch")
