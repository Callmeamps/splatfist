# block_state.gd
extends PlayerState

func enter():
	player.sprite.play("block")
	# In a real game, you would set a variable like player.is_blocking = true
	# so the take_damage function knows to reduce stamina instead of HP.

func exit():
	# player.is_blocking = false
	pass

func process_physics(delta: float):
	if player.is_on_floor():
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.2) # Apply friction
	else:
		player.velocity.y += player.character_data.gravity * delta

	# Transition out when block button is released
	if not Input.is_action_pressed("block"):
		if player.is_on_floor():
			state_machine.set_state("Idle")
		else:
			state_machine.set_state("Fall")
