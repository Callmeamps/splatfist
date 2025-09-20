# launcher.gd
extends BaseAttackState

func enter():
	attack_animation_name = "launcher"
	super.enter()
	
	var damage = player.character_data.launcher_dmg
	# A vertical hitbox to launch opponents
	spawn_hitbox(damage, Vector2(40, 80), Vector2(20, -60), 0.18)
