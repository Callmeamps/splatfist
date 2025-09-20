# crouch_state.gd
extends PlayerState

func enter():
	player.sprite.play("crouch")
	player.set_crouching(true)
	player.velocity.x = 0

func exit():
	player.set_crouching(false)

func process_physics(delta: float):
	var input_axis = Input.get_axis("move_left", "move_right")

	# Transitions
	if not Input.is_action_pressed("crouch"):
		state_machine.set_state("Idle")
		return
		
	if not is_zero_approx(input_axis):
		state_machine.set_state("CrouchWalk")
		return
		
	# Add transitions for crouch attacks here
	# if Input.is_action_just_pressed("attack_light"):
	#     state_machine.set_state("CrouchLightAttack")
