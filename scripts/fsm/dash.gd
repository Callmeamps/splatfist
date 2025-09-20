# dash_state.gd
extends PlayerState

var dash_timer: float = 0.0

func enter():
	dash_timer = player.character_data.dash_time
	player.velocity.y = 0
	player.velocity.x = player.facing_direction * player.character_data.dash_speed
	player.sprite.play("dash")

func process_physics(delta: float):
	dash_timer -= delta
	
	# When the dash is over, transition to Run or Idle.
	if dash_timer <= 0:
		var input_axis = Input.get_axis("move_left", "move_right")
		if not is_zero_approx(input_axis):
			state_machine.set_state("Run")
		else:
			state_machine.set_state("Idle")
