extends Base_State

class_name Jump_State

## This timer will be used to determine the coyote time the player has after leaving a platform to still perform a jump.
@export var coyote_timer: Timer 

@onready var JUMP_VELOCITY: float = (-1.0) * ((2.0 * parent.JUMP_HEIGHT) / parent.JUMP_TIME_TO_PEAK) 
@onready var JUMP_GRAVITY: float = (-1.0) * ((-2.0 * parent.JUMP_HEIGHT) / (parent.JUMP_TIME_TO_PEAK * parent.JUMP_TIME_TO_PEAK))
@onready var jumpOne: AudioStreamPlayer = $jumpSound

var jump_height_timer: float = 0.0
## Number that stores the initial velocity the player had when entering the jumping state. 
## Is used to add a portion of the momentum to the jump while in the air. 
## Will be multiplied with parent.MOMENTUM_MODIFIER to determine how much momentum the player can take with them.
var additional_horizontal_velocity: float = 0.0

func enter() -> void: 
	super()
	jumpOne.play()
	print("changed state to jumping")
	print("JUMP_VELOCITY: ", JUMP_VELOCITY, " | JUMP_GRAVITY: ", JUMP_GRAVITY)
	# set player velocity to calculated jump velocity
	parent.velocity.y = JUMP_VELOCITY
	# Store the initial horizontal velocity and muliply with the Momentum Modifier 
	additional_horizontal_velocity = parent.velocity.x * parent.MOMENTUM_MODIFIER
	# Apply some of the initial horizontal momentum to the jump
	parent.velocity.x += additional_horizontal_velocity 
	
	print("parent velocity x: ", parent.velocity.x)
	coyote_timer.stop()

func exit() -> void: 
	parent.has_jumped = true

func process_input(_event: InputEvent) -> Base_State: 
	# If the jump button is released, transition to falling state
	if !Input.is_action_pressed("jump"):
		return fall_state
	if !parent.has_dashed and Input.is_action_pressed("dash"):
		return dash_state
	if parent.is_on_wall() and Input.is_action_just_pressed("jump") and parent.is_wall_holdable():
		return jump_state
	if Input.is_action_pressed("hold") and parent.is_wall_holdable():
		parent.snap_to_wall()
		return wall_hold_state
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
	parent.velocity.x = direction * (parent.MOVE_SPEED) + additional_horizontal_velocity
	if direction != 0:
		parent.set_facing_direction(direction)
	parent.move_and_slide()
	
	# do NOT return self - Player will launch straight into the air
	return null


func process_frame(_delta: float) -> Base_State:
	# set animation_name 
	animation_name = "jump"
	#play animation
	if parent.animation_player.has_animation(animation_name):
		var anim_length : float = parent.animation_player.get_animation(animation_name).get_length()
		var custom_speed : float = anim_length / parent.JUMP_TIME_TO_PEAK
		parent.animation_player.play(animation_name, -1, custom_speed, false)
	return null;
