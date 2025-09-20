# FILE: scripts/fsm/grabbed.gd
extends PlayerState

# How long the player is stuck in the grab before being released.
var timer: float = 0.0

func enter():
	# Stop all player movement immediately.
	player.velocity = Vector2.ZERO
	playback.travel("grabbed") # Assumes you have a "grabbed" animation
	timer = player.character_data.grab_duration

func physics_update(delta):
	# The player is helpless, so we don't listen for input.
	# We just stop them and wait for the timer to run out.
	player.velocity = Vector2.ZERO
	player.move_and_slide()
	
	timer -= delta
	if timer <= 0:
		# After being held, the player is put into the "fall" state.
		# This could later be a "knockdown" state.
		fsm.transition_to("Fall")