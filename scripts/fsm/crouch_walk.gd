# crouch_walk_state.gd
extends PlayerState

func enter():
	player.sprite.play("crouch_walk")
	player.set_crouching(true)

func exit():
	player.set_crouching(false)

func process_physics(delta: float):
	var input_axis = Input.get_axis("move_left", "move_right")
	
	# Use crouch walk speed
	var target_speed = input_axis * player.character_data.crouch_walk_speed
	player.velocity.x = lerp(player.velocity.x, target_speed, player.character_data.ground_acceleration * delta)
	player.set_facing_direction(input_axis)

	# Transitions
	if not Input.is_action_pressed("move_down"):
		state_machine.set_state("Idle")
		return
	
	if is_zero_approx(input_axis):
		state_machine.set_state("Crouch")
		return
