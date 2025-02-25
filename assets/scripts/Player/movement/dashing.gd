extends Base_State

class_name Dash_State

@export var dash_timer: Timer

@onready var dash_speed_modifier: float = parent.DASH_SPEED * parent.MOVE_SPEED
@onready var dash_timer_length: float = parent.DASH_DISTANCE / parent.DASH_SPEED
@onready var dashSound= $dashSound
@onready var dash_direction: Vector2
var up: int = -1
var down: int = 1
var left: int = -1
var right: int = 1
var null_vector: Vector2 = Vector2(0,0)

func set_dash_direction(dir: Vector2) -> void:
	dash_direction = dir

func get_dash_direction() -> Vector2:
	return dash_direction

func enter() -> void:
	super()
	dashSound.play()
	
	# set flag only if state was not induced from the outside, i.e. dash_direction
	# is still the null_vector
	if get_dash_direction() == null_vector:
		print("the dashing state was entered normallly thus the dash flag has been set to true")
		parent.has_dashed = true
	
	# Start the dash timer
	dash_timer.wait_time = dash_timer_length
	dash_timer.one_shot = true
	dash_timer.start()
	# set player speed to 0,0 for full control over dash direction
	parent.velocity = null_vector
	
	# when the state is induced from the outside, the dash direction has already
	# been changed and therefore the dash_direction doesn't have to be calculated
	# anymore
	if get_dash_direction() != null_vector:
		pass
	# calculating eight-directional dashing depending on which inputs are given
	elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_up"):
		set_dash_direction(Vector2(left, up).normalized())
		parent.set_facing_direction(left)
	elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_down"):
		set_dash_direction(Vector2(left, down).normalized())
		parent.set_facing_direction(left)
	elif Input.is_action_pressed("move_right") and Input.is_action_pressed("move_up"):
		set_dash_direction(Vector2(right, up).normalized())
		parent.set_facing_direction(right)
	elif Input.is_action_pressed("move_right") and Input.is_action_pressed("move_down"): 
		set_dash_direction(Vector2(right, down).normalized())
		parent.set_facing_direction(right)
	elif Input.is_action_pressed("move_left"): 
		set_dash_direction(Vector2(left, 0))
		parent.set_facing_direction(left)
	elif Input.is_action_pressed("move_right"):
		set_dash_direction(Vector2(right, 0))
		parent.set_facing_direction(right)
	elif Input.is_action_pressed("move_up"): 
		set_dash_direction(Vector2(0, up))
	elif Input.is_action_pressed("move_down"):
		set_dash_direction(Vector2(0, down))
	else: 
		set_dash_direction(Vector2(parent.facing_direction, 0))


func exit() -> void:
	# set dash_direction back to null_vector to be able to check for induction
	# again the next time the state is called
	set_dash_direction(null_vector)


func process_input(event: InputEvent) -> Base_State:
	return null


func _process_physics(_delta: float) -> Base_State:
	# Handle physics logic during the dash (if needed)
	parent.velocity = dash_direction * parent.DASH_SPEED
	parent.move_and_slide()
	return null


func process_frame(_delta: float) -> Base_State:
	# set animation_name 
	animation_name = "dash"
	#play animation
	if parent.animation_player.has_animation(animation_name):
		var anim_length : float = parent.animation_player.get_animation(animation_name).get_length()
		var custom_speed : float = anim_length / dash_timer_length
		parent.animation_player.play(animation_name, -1, custom_speed, false)
	
	# transitions to next state
	if Input.is_action_pressed("jump"):
		if parent.is_on_floor():
			dash_timer.stop()
			parent.has_dashed = true
			return jump_state
		if parent.is_on_wall():
			dash_timer.stop()
			parent.has_dashed = true
			return jump_state
		if !parent.is_on_wall() and !parent.is_on_floor():
			parent.has_dashed = true
	if dash_timer.is_stopped():
		if parent.is_on_floor() and Input.is_action_pressed("move_left") or parent.is_on_floor() and Input.is_action_pressed("move_right"):
			return walk_state
		if parent.is_on_floor() and !Input.is_action_pressed("move_left") or parent.is_on_floor() and !Input.is_action_pressed("move_right"):
			return idle_state
		if Input.is_action_pressed("hold") and parent.is_wall_holdable():
			parent.snap_to_wall()
			return wall_hold_state
		if !parent.is_on_floor() :
			return fall_state
		return idle_state
	return null


func _on_dash_timer_timeout() -> void:
	var jump_velocity = (-1.0) * ((-2.0 * parent.JUMP_HEIGHT) / (parent.JUMP_TIME_TO_PEAK * parent.JUMP_TIME_TO_PEAK))
	var fall_gravity = (-1) * ((-2 * parent.JUMP_HEIGHT) / (parent.JUMP_TIME_TO_DESCENT * parent.JUMP_TIME_TO_DESCENT))
	# Reset the velocity when dash timer timed out
	if parent.velocity.x < -parent.MOVE_SPEED or parent.velocity.x > parent.MOVE_SPEED:
		parent.velocity.x /= dash_speed_modifier
	if parent.velocity.y < jump_velocity or parent.velocity.y > fall_gravity: 
		parent.velocity.y /= dash_speed_modifier
