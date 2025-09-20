# run_state.gd
extends PlayerState

var last_dir: int = 0
var last_dir_time: float = 0.0

func enter():
	player.sprite.play("run")
	# Reset dash detection on entering run state
	last_dir = 0
	last_dir_time = 0.0

func process_physics(delta: float):
	# --- Apply Gravity ---
	# Ensures the player sticks to slopes and can fall off ledges.
	if not player.is_on_floor():
		player.velocity.y += player.character_data.gravity * delta
		state_machine.set_state("Fall")
		return

	# --- Handle Input ---
	var input_axis = Input.get_axis("move_left", "move_right")
	
	# --- Horizontal Movement ---
	# Accelerate the player towards the target run speed.
	var target_speed = input_axis * player.character_data.run_speed
	player.velocity.x = lerp(player.velocity.x, target_speed, player.character_data.ground_acceleration * delta)
	
	# Update the direction the player is facing
	player.set_facing_direction(input_axis)

	# --- State Transitions ---
	# Transition to Idle if the player stops moving.
	if is_zero_approx(input_axis):
		state_machine.set_state("Idle")
		return
	
	# Transition to Jump.
	if Input.is_action_just_pressed("jump"):
		state_machine.set_state("Jump")
		return
		
	# Transition to Dash on double-tap.
	_check_for_dash(input_axis)


func _check_for_dash(current_dir: float):
	# We only care about integer directions (-1, 1)
	var dir_int = int(sign(current_dir))
	if dir_int == 0:
		return

	var current_time = Time.get_ticks_msec()
	# If the direction is the same as the last and within the time window...
	if dir_int == last_dir and (current_time - last_dir_time) < 220: # 220ms window
		state_machine.set_state("Dash")
	else:
		# Otherwise, record this press for the next check.
		last_dir = dir_int
		last_dir_time = current_time
