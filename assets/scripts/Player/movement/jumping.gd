extends Base_State

@export var coyote_timer: Timer 

@onready var JUMP_VELOCITY: float = (-1.0) * ((2.0 * parent.JUMP_HEIGHT) / parent.JUMP_TIME_TO_PEAK) 
@onready var JUMP_GRAVITY: float = (-1.0) * ((-2.0 * parent.JUMP_HEIGHT) / (parent.JUMP_TIME_TO_PEAK * parent.JUMP_TIME_TO_PEAK))

var jump_height_timer: float = 0.0

func enter() -> void: 
	super()
	print("changed state to jumping")
	print("JUMP_VELOCITY: ", JUMP_VELOCITY, " | JUMP_GRAVITY: ", JUMP_GRAVITY)
	# set player velocity to calculated jump velocity
	parent.velocity.y = JUMP_VELOCITY
	coyote_timer.stop()


func process_input(_event: InputEvent) -> Base_State: 
	# If the jump button is released, transition to falling state
	if !Input.is_action_pressed("jump"):
		return fall_state
	if !parent.has_dashed and Input.is_action_pressed("dash"):
		return dash_state
	return null

func _process_physics(delta: float) -> Base_State:
	parent.velocity.y += JUMP_GRAVITY * delta
	# add delta to jump_height_timer
	jump_height_timer += delta
	print("state jumping: parent velocity at ", parent.velocity.y)
	
	# checking for player falling
	if parent.velocity.y > 0 or jump_height_timer == parent.JUMP_TIME_TO_PEAK:
		return fall_state
	
	# aerial movement 
	var direction = Input.get_axis("move_left", "move_right")
	parent.velocity.x = direction * (parent.MOVE_SPEED)
	if direction != 0:
		parent.set_facing_direction(direction)
	parent.move_and_slide()
	
	# do NOT return self - Player will launch straight into the air
	return null
