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
		player.sprite.play("air_jump") # Could be a different animation
	
	# Transition to the Fall state to handle air physics.
	# if state_machine.get_state("Jump") and player.sprite.animation_finished:
	state_machine.set_state("Fall")
