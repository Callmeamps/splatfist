# mid_attack_state.gd
extends BaseAttackState

func enter():
	attack_animation_name = "mid_attack"
	super.enter()
	
	var damage = player.character_data.mid_dmg
	spawn_hitbox(damage, Vector2(65, 40), Vector2(55, -15), 0.15)
