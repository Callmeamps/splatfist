extends BaseAttackState

# Preload the Grabbox scene so we can create instances of it.
var grabbox_scene = preload("res://scenes/grabbox.tscn")

func enter():
	# This runs the animation logic from BaseAttackState
	super.enter() 
	
	# --- Spawn the Grabbox ---
	var grabbox_instance = grabbox_scene.instantiate()
	
	# We'll connect the signal from the grabbox to a function on the player
	grabbox_instance.grab_successful.connect(player.on_grab_success)
	
	# Position the grabbox in front of the player
	var direction = 1 if player.get_node("Sprite2D").is_flipped_h() else -1
	grabbox_instance.position.x = 60 * -direction # Adjust 60 as needed
	
	player.add_child(grabbox_instance)
