extends Base_State

@export var fall_state: Base_State
@export var jump_state: Base_State
@export var walk_state: Base_State
#@export var dash_state: State

func enter() -> void: 
	super()
	
	parent.has_jumped = false
	
	print("changed state to idling")
#	parent.move_and_slide()
#	parent.apply_floor_snap()
	parent.velocity.x = 0

func process_input(_event: InputEvent) -> Base_State:
	if Input.is_action_just_pressed("jump"): #and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
			return walk_state
	#if Input.is_action_just_pressed("dash"):
	#	return dash_state
	return null

func _process_physics(delta: float) -> Base_State:
	if !parent.is_on_floor():
		return fall_state
	return self
