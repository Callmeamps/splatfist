# base_attack_state.gd
# DO NOT attach this script directly to a node.
# Other attack states will EXTEND this script.
class_name BaseAttackState
extends PlayerState

# This is the animation that the state will play.
# The child state (e.g., LightAttackState) will set this value.
var attack_animation_name: String = ""

func enter():
	# Ensure the child state has provided an animation name.
	if attack_animation_name.is_empty():
		push_error("Attack state entered without an 'attack_animation_name' set!")
		state_machine.set_state("Idle")
		return

	player.sprite.play(attack_animation_name)
	player.sprite.connect("animation_finished", _on_animation_finished)
	
	# Halt horizontal movement for ground attacks to prevent sliding.
	if player.is_on_floor():
		player.velocity.x = 0

func exit():
	# Clean up the signal connection to prevent it from firing when not in this state.
	if player.sprite.is_connected("animation_finished", _on_animation_finished):
		player.sprite.disconnect("animation_finished", _on_animation_finished)

func process_physics(delta: float):
	# Apply gravity if the attack is performed in the air.
	if not player.is_on_floor():
		player.velocity.y += player.character_data.gravity * delta
	else:
		# Apply some friction to stop any residual movement.
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.1)


func _on_animation_finished(anim_name):
	# Only react if the finished animation is the one this state started.
	if anim_name == attack_animation_name:
		# Return to a neutral state.
		if player.is_on_floor():
			state_machine.set_state("Idle")
		else:
			state_machine.set_state("Fall")

# Helper function for child states to call.
func spawn_hitbox(damage: int, size: Vector2, offset: Vector2, duration: float):
	if not player.character_data.hitbox_scene: return
	
	var hitbox = player.character_data.hitbox_scene.instantiate()
	player.hitboxes_node.add_child(hitbox)
	
	# Position and configure the hitbox based on parameters.
	hitbox.global_position = player.global_position + offset * Vector2(player.facing_direction, 1)
	# NOTE: Your hitbox scene will need a script with a `setup` function
	# that takes (damage, size, duration, owner_player) as arguments.
	if hitbox.has_method("setup"):
		hitbox.setup(damage, size, duration, player)
