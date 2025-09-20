# jump_state.gd
extends PlayerState

func enter():
	# This state's only job is to apply the initial upward velocity.
	# The Fall state will handle all the airborne logic.

	# Ground Jump
	if player.is_on_floor():
		player.velocity.y = player.character_data.jump_velocity
		player.jumps_left = player.character_data.max_jumps - 1
		player.sprite.play("jump")
	# Air Jump (Double Jump)
	elif player.jumps_left > 0:
		player.velocity.y = player.character_data.double_jump_velocity
		player.jumps_left -= 1
		player.sprite.play("double_jump") # Could be a different animation
	
	# Immediately transition to the Fall state to handle air physics.
	state_machine.set_state("Fall")

func process_physics(delta: float):
	# --- Variable Jump Height ---
	# If the player releases the jump button early, cut the upward velocity.
	# This gives the player more control over jump height.
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= 0.45
