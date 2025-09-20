# fall_state.gd
extends PlayerState

func enter():
	player.sprite.play("fall")

func process_physics(delta: float):
	# --- Apply Gravity ---
	# Accelerate downwards, but not past the max fall speed.
	player.velocity.y += player.character_data.gravity * delta
	if player.velocity.y > player.character_data.max_fall_speed:
		player.velocity.y = player.character_data.max_fall_speed
	
	# --- Horizontal Air Control ---
	var input_axis = Input.get_axis("move_left", "move_right")
	var target_speed = input_axis * player.character_data.run_speed # You might want a separate air speed
	player.velocity.x = lerp(player.velocity.x, target_speed, player.character_data.air_acceleration * delta)
	player.set_facing_direction(input_axis)

	# --- Variable Jump Height ---
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= 0.45

	# --- State Transitions ---
	# Check for landing.
	if player.is_on_floor():
		# If holding a direction, go straight to running. Otherwise, idle.
		if not is_zero_approx(input_axis):
			state_machine.set_state("Run")
		else:
			state_machine.set_state("Idle")
		return
		
	# Check for Double Jump.
	if Input.is_action_just_pressed("jump") and player.jumps_left > 0:
		state_machine.set_state("Jump")
		return
		
	# Check for Air Dash.
	if Input.is_action_just_pressed("dodge") and player.air_dashes_left > 0:
		state_machine.set_state("AirDash")
		return
