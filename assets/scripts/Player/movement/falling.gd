extends Base_State

class_name Fall_State

@export var coyote_timer: Timer

@onready var FALL_GRAVITY: float =  (-1) * ((-2 * parent.JUMP_HEIGHT) / (parent.JUMP_TIME_TO_DESCENT * parent.JUMP_TIME_TO_DESCENT))

func enter() -> void: 
	super()
	print("changed state to falling")
	print("state falling: enter: parent has dashed: ", parent.has_dashed)


func process_input(_event: InputEvent) -> Base_State: 
	if Input.is_action_just_pressed("jump"):
		if !coyote_timer.is_stopped(): 
			print("remaining coyote time ",coyote_timer.time_left)
			coyote_timer.stop()
			return jump_state
	if !parent.has_dashed and Input.is_action_just_pressed("dash"): 
		return dash_state
	if parent.is_on_wall() and Input.is_action_pressed("hold"):
		return wall_hold_state
	return null


func _process_physics(delta: float) -> Base_State: 
	if not parent.is_on_floor():
		parent.velocity.y += FALL_GRAVITY * delta
	
	var direction = Input.get_axis("move_left", "move_right")
	parent.velocity.x = direction * (parent.MOVE_SPEED)
	if direction != 0:
		parent.set_facing_direction(direction)
	parent.move_and_slide()
	
	print("state falling: parent y velocity at ", parent.velocity.y)
	
	# if player stops falling and moves change state to walking
	if parent.is_on_floor():
		if parent.velocity.x != 0: 
			return walk_state
		if parent.velocity.x == 0: 
			return idle_state
	return null 
