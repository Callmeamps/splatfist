# mod_light_attack_state.gd
extends BaseAttackState

func enter():
	attack_animation_name = "bash"
	super.enter()
	
	var damage = player.character_data.bash_dmg
	# A bigger, more powerful hitbox
	spawn_hitbox(damage, Vector2(80, 50), Vector2(70, -20), 0.2)
