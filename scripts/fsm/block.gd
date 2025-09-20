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
	player.get_node("Hitbox").set_deferred("disabled", true)
	
	# --- Standard Logic ---
	playback.travel("dodge")
	var direction = 1 if player.get_node("Sprite2D").is_flipped_h() else -1
	player.velocity.x = dodge_impulse * -direction

func exit():
	# --- Remove Invulnerability ---
	# Re-enable the hurtbox when the dodge state is finished.
	player.get_node("Hitbox").set_deferred("disabled", false)

func physics_update(delta):
	if not player.is_on_floor():
		player.velocity.y += gravity * delta
	
	player.move_and_slide()
	
	if not playback.is_playing():
		fsm.transition_to("Idle") if player.is_on_floor() else fsm.transition_to("Fall")
	# --- Parry Input Logic ---
	# Get the player's forward direction.
	var forward_input = Input.get_axis("move_left", "move_right")
	var player_is_facing_right = not player.get_node("Sprite2D").is_flipped_h()
	
	var is_pressing_forward = (player_is_facing_right and forward_input > 0) or (not player_is_facing_right and forward_input < 0)

	# If player presses forward while blocking, transition to Parry.
	if is_pressing_forward:
		fsm.transition_to("Parry")
		return

	# --- Handle Exiting Block State ---
	# If the block button is released, go to idle.
	if Input.is_action_just_released("block"):
		fsm.transition_to("Idle")
