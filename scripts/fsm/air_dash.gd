# air_dash_state.gd
extends PlayerState

var air_dash_timer: float = 0.0
var air_dash_duration: float = 0.15 # How long the dash lasts

func enter():
	player.air_dashes_left -= 1
	air_dash_timer = air_dash_duration
	player.sprite.play("air_dash")

	# Determine dash direction (8-way input)
	var dash_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("jump", "crouch") # Assumes you have these inputs mapped
	).normalized()
	
	# If no direction is held, dash forward.
	if dash_direction == Vector2.ZERO:
		dash_direction = Vector2(player.facing_direction, 0)
	
	player.velocity = dash_direction * player.character_data.air_dash_speed

func process_physics(delta: float):
	air_dash_timer -= delta
	
	# When the air dash is over, return to the Fall state.
	# The momentum from the dash will be naturally handled by the Fall state's physics.
	if air_dash_timer <= 0:
		state_machine.set_state("Fall")
