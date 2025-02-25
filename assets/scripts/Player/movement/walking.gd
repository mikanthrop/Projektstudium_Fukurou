extends Base_State

class_name Walk_State


@export var coyote_timer: Timer
@onready var walking = $walkSound

# called when state is changed to walking
func enter() -> void: 
	walking.play()
	
	if parent.velocity.x == 0:
		parent.velocity.x += parent.MOVE_SPEED


func exit() -> void:
	walking.stop()
	
	parent.has_jumped = false
	parent.has_dashed = false
	
	coyote_timer.stop()
	coyote_timer.start()


# handles input
func process_input(_event: InputEvent) -> Base_State: 
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		exit()
		return jump_state
	if Input.is_action_pressed("hold") and parent.is_wall_holdable():
		parent.snap_to_wall()
		return wall_hold_state
	if Input.is_action_just_pressed("dash"):
		return dash_state
	if !InputEvent:
		return idle_state
	return null


# handles actual movement and returns states that change without needing inputs
func _process_physics(delta: float) -> Base_State:
	parent.velocity.y += gravity*delta
	# if player has negativ y velocity change state to falling
	if parent.velocity.y < 0 and !parent.is_on_floor():
		return idle_state
	if parent.velocity.y > 0 and !parent.is_on_floor():
		return fall_state
	
	# let's player move left and right
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		parent.velocity.x = direction * parent.MOVE_SPEED
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.MOVE_SPEED)
	parent.move_and_slide()
	
	if parent.velocity.x == 0: 
		return idle_state
	else: 
		parent.set_facing_direction(direction)
	
	# if player doesn't move change state to idle
	return null


func process_frame(_delta: float) -> Base_State:
	animation_name = "walk"
	#play animation
	if parent.animation_player.has_animation(animation_name):
		parent.animation_player.play(animation_name)
	return null;
