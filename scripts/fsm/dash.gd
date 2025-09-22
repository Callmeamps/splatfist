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
			state_machine.set_state("Walk")
		else:
			state_machine.set_state("Idle")

func exit():
	# Reset the player's horizontal velocity to prevent sliding.
	# The next state (Idle or Run) will then take over correctly.
	player.velocity.x = 0
	dash_timer = 0
