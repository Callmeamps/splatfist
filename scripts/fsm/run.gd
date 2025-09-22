# run_state.gd
extends PlayerState

func enter():
	player.sprite.play("run")

func process_physics(delta: float):
	# --- Apply Gravity ---
	# Ensures the player sticks to slopes and can fall off ledges.
	if not player.is_on_floor():
		state_machine.set_state("Fall")
		return

	# --- Handle Input ---
	var input_axis = Input.get_axis("move_left", "move_right")

	#if Input.is_action_pressed("mod"):
	# --- Horizontal Movement ---
	# Accelerate the player towards the target run speed.
	var target_speed = input_axis * player.character_data.run_speed
	player.velocity.x = lerp(player.velocity.x, target_speed, player.character_data.ground_acceleration * delta)
	
	# Update the direction the player is facing

	# --- State Transitions ---
	# Transition to dash

	
	# Transition back to Walk if the modifier is released but still moving.
	if not Input.is_action_pressed("mod") and input_axis != 0:
		state_machine.set_state("Walk")
		return

	# Transition to Idle if the player stops moving.
	if input_axis == 0:
		state_machine.set_state("Idle")
		return
	
	# Transition to Jump.
	if Input.is_action_just_pressed("jump"):
		state_machine.set_state("Jump")
		return
		

func process_input(event: InputEvent) -> void:
# Transitions
	if event.is_action_just_pressed("move_right"):
		state_machine._check_for_dash(1)
	elif event.is_action_just_pressed("move_left"):
		state_machine._check_for_dash(-1)
