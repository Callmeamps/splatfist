# light_attack_state.gd
extends BaseAttackState

func enter():
	# Set the animation for the base class to use
	attack_animation_name = "light_attack"
	# Call the parent's enter function to start the animation and connect signals
	super.enter()
	
	# Spawn the hitbox with this attack's specific properties
	# Parameters are: damage, size, offset, duration
	var damage = player.character_data.light_dmg
	spawn_hitbox(damage, Vector2(50, 30), Vector2(45, -10), 0.1)
