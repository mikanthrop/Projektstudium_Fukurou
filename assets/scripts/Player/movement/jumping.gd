extends Base_State

@export var fall_state: Base_State
@export var idle_state: Base_State
@export var walk_state: Base_State

@onready var coyote_timer: Timer = get_node("../../CoyoteTimer")


func enter() -> void: 
	super()
	parent.has_jumped = true
	print("changed state to jumping")
	parent.velocity.y = parent.JUMP_VELOCITY
	coyote_timer.stop()

func _process_physics(delta: float) -> Base_State: 
	parent.velocity.y += gravity*delta
	# checking for player falling
	if parent.velocity.y > 0:
		return fall_state
	
	# flipping animations
#	if movement != 0: 
#		parent.animations.flip_h = movement < 0
	
	# aerial movement 
	var movement = Input.get_axis("move_left", "move_right") * parent.MOVE_SPEED
	parent.velocity.x = movement
	parent.move_and_slide()
	
	# do NOT return self - Player will launch straight into the air
	return null

# unnecessary but for future reference
#	if parent.is_on_floor():
#		if movement !=0:
#			return walk_state
#		return idle_state
