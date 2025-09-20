extends PlayerState

# The parry will only be active for a very short time.

var parry_timer: float = 0.0

func enter():
	# --- Endurance Check ---
	if player.character_data.endurance < 12:
		# If you can't afford it, go back to blocking.
		state_machine.transition_to("Block")
		return

	# --- Subtract Endurance Cost ---
	player.character_data.endurance -= 12
	print("Player Endurance: ", player.character_data.endurance)

	# --- Animation & Timer ---
	player.spirte.play("parry")
	parry_timer = player.character_data.parry_window
	
	# --- Parry Hitbox (Placeholder) ---
	# In the future, we'll enable a special hitbox here to detect attacks.
	# For now, we're just building the state itself.


func physics_update(delta):
	# Decrement the timer.
	parry_timer -= delta
	
	# When the parry window is over, transition back to the Block state.
	if parry_timer <= 0:
		state_machine.transition_to("Block")
		

func exit():
	# Clean up any parry-related effects here.
	pass
