extends Base_State

class_name Dash_State

@export var dash_timer: Timer

@onready var dash_speed_modifier: float = parent.DASH_SPEED * parent.MOVE_SPEED
@onready var dash_timer_length: float = parent.DASH_DISTANCE / parent.DASH_SPEED

var dash_direction: Vector2
var up: int = -1
var down: int = 1
var left: int = -1
var right: int = 1

func enter() -> void:
	super()
	print("changed state to dashing")
	# set flag
	parent.has_dashed = true
	# Start the dash timer
	dash_timer.wait_time = dash_timer_length
	dash_timer.one_shot = true
	dash_timer.start()
	print("state dashing: enter: dash_timer time: ", dash_timer.time_left)
	# set player speed to 0,0 for full control over dash direction
	parent.velocity = Vector2(0, 0)
	
	# eight-directional dashing
	if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_up"):
		dash_direction = Vector2(left, up).normalized()
		parent.set_facing_direction(left)
	elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_down"):
		dash_direction = Vector2(left, down).normalized()
		parent.set_facing_direction(left)
	elif Input.is_action_pressed("move_right") and Input.is_action_pressed("move_up"):
		dash_direction = Vector2(right, up).normalized()
		parent.set_facing_direction(right)
	elif Input.is_action_pressed("move_right") and Input.is_action_pressed("move_down"): 
		dash_direction = Vector2(right, down).normalized()
		parent.set_facing_direction(right)
	elif Input.is_action_pressed("move_left"): 
		dash_direction = Vector2(left, 0)
		parent.set_facing_direction(left)
	elif Input.is_action_pressed("move_right"):
		dash_direction = Vector2(right, 0)
		parent.set_facing_direction(right)
	elif Input.is_action_pressed("move_up"): 
		dash_direction = Vector2(0, up)
	elif Input.is_action_pressed("move_down"):
		dash_direction = Vector2(0, down)
	else: 
		dash_direction = Vector2(parent.facing_direction, 0)

func exit() -> void:
	pass


func process_input(event: InputEvent) -> Base_State:
	print("state dashing: process input: ", event)
	if Input.is_action_pressed("jump"):
			return jump_state
	
	return null


func _process_physics(_delta: float) -> Base_State:
	# Handle physics logic during the dash (if needed)
	parent.velocity = dash_direction * parent.DASH_SPEED
	print("state dashing: physics: dash_direction: ", dash_direction)
	parent.move_and_slide()
	
	return null


func process_frame(delta: float) -> Base_State:
	# transitions to next state
	if dash_timer.is_stopped(): 
		if parent.is_on_floor() and Input.is_action_pressed("jump"):
			return jump_state
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			return walk_state
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
