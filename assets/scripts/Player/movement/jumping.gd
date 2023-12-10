extends Base_State

@export var coyote_timer: Timer 

@export var jump_height: float
@export var jump_time_to_peak: float

@onready var JUMP_VELOCITY: float = (-1.0) * ((2.0 * jump_height) / jump_time_to_peak) 
@onready var JUMP_GRAVITY: float = (-1.0) * ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))


func enter() -> void: 
	super()
	print("changed state to jumping")
	print("JUMP_VELOCITY: ", JUMP_VELOCITY, " | JUMP_GRAVITY: ", JUMP_GRAVITY)
	
	# set player velocity to calculated jump velocity
	parent.velocity.y = JUMP_VELOCITY
	coyote_timer.stop()


func _process_input(_event: InputEvent) -> Base_State: 
	print("state jumping: Input before while: ", _event)
	while _event.is_pressed():
		print("state jumping: Input: ", Input)
		parent.velocity.y = 0
		return fall_state
	return null

func _process_physics(delta: float) -> Base_State:
	parent.velocity.y += JUMP_GRAVITY * delta
	print("state jumping: parent velocity at ", parent.velocity.y)
	
	# checking for player falling
	if parent.velocity.y > 0:
		return fall_state
	
	# flipping animations
#	if movement != 0: 
#		parent.animations.flip_h = movement < 0
	
	# aerial movement 
	var movement = Input.get_axis("move_left", "move_right") * (parent.MOVE_SPEED)
	parent.velocity.x = movement
	parent.move_and_slide()
	
	# do NOT return self - Player will launch straight into the air
	return null
