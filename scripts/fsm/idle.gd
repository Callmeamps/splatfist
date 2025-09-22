# idle.gd
extends PlayerState

func enter():
	player.sprite.play("idle")
	player.velocity.x = 0
	# You could use lerp for a nice slowdown effect:
	# player.velocity.x = lerp(player.velocity.x, 0, 0.2)

func process_physics(delta: float):
	# Apply gravity
	if not player.is_on_floor():
		player.velocity.y += player.character_data.gravity * delta

	# Check for transitions
	if Input.is_action_just_pressed("jump"):
		state_machine.set_state("Jump")
		return

	if Input.get_axis("move_left", "move_right") != 0:
		state_machine.set_state("Run")
		return

	# Fall off a ledge
	if not player.is_on_floor() and player.velocity.y > 0:
		state_machine.set_state("Fall")
		return

func process_input(event: InputEvent) -> void:
# Transitions
	if event.is_action_just_pressed("move_right"):
		state_machine._check_for_dash(1)
	elif event.is_action_just_pressed("move_left"):
		state_machine._check_for_dash(-1)

