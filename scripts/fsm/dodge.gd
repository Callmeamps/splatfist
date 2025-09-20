# dodge_state.gd
extends PlayerState

var timer: float = 0.0

func enter():
	var cost = player.character_data.dodge_stamina_cost
	if player.spend_stamina(cost):
		timer = player.character_data.dodge_invuln_time
		player.sprite.play("dodge")
		# Make the player temporarily invincible by putting them on a different physics layer
		player.set_collision_layer_value(10, true) # Assuming layer 10 is for "invincible players"
		player.set_collision_mask_value(10, false)
		
		# A short burst of movement
		player.velocity.x = player.character_data.dash_speed * 0.8 * player.facing_direction
		if not player.is_on_floor():
			player.velocity.y = 0
	else:
		# Not enough stamina, immediately exit.
		state_machine.set_state("Idle" if player.is_on_floor() else "Fall")


func exit():
	# IMPORTANT: Always restore the collision layer when exiting the state.
	player.set_collision_layer_value(10, false)
	player.set_collision_mask_value(10, true)

func process_physics(delta: float):
	timer -= delta
	if timer <= 0:
		state_machine.set_state("Idle" if player.is_on_floor() else "Fall")
