extends PlayerState

func enter():
	# --- Endurance Check ---
	if player.character_data.endurance < 18:
		fsm.transition_to("Idle") if player.is_on_floor() else fsm.transition_to("Fall")
		return

	# --- Subtract Endurance Cost ---
	player.character_data.endurance -= 18
	print("Player Endurance: ", player.character_data.endurance)

	# --- Add Invulnerability ---
	# IMPORTANT: This assumes your player's hurtbox is a CollisionShape2D node named "Hitbox".
	# If it's named something else, you MUST change "Hitbox" below.
	player.hitboxes_node.set_deferred("disabled", true)
	
	# --- Standard Logic ---
	playback.travel("dodge")
	var direction = 1 if player.sprite.is_flipped_h() else -1
	player.velocity.x = dodge_impulse * -direction

func exit():
	# --- Remove Invulnerability ---
	# Re-enable the hurtbox when the dodge state is finished.
	player.hitboxes_node.set_deferred("disabled", false)

func physics_update(delta):
	if not player.is_on_floor():
		player.velocity.y += gravity * delta
	
	player.move_and_slide()
	
	if not playback.is_playing():
		fsm.transition_to("Idle") if player.is_on_floor() else fsm.transition_to("Fall")