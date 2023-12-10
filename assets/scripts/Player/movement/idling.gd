extends Base_State

@export var coyote_timer: Timer


func enter() -> void: 
	super()
	print("changed state to idling")
	parent.velocity.x = 0


func exit() -> void: 
	parent.was_on_floor = false
	coyote_timer.start()


func process_input(_event: InputEvent) -> Base_State:
	if Input.is_action_pressed("jump"): #and parent.is_on_floor():
		return jump_state
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			return walk_state
	#if Input.is_action_just_pressed("dash"):
	#	return dash_state
	return null


func _process_physics(_delta: float) -> Base_State:
	if !parent.is_on_floor():
		self.exit()
		return fall_state
	return null
