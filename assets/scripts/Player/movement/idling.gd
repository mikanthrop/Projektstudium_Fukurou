extends Base_State

class_name Idle_State

@export var coyote_timer: Timer



func enter() -> void: 
	super()
	print("changed state to idling")
	
	# set jump and dash flags to false 
	parent.has_jumped = false
	parent.has_dashed = false
	
	# set parent velocity to zero
	parent.velocity.x = 0
	parent.animation_player.play("beak_growing")
	


func exit() -> void: 
	# start coyote timer (breakable platforms)
	coyote_timer.start()


func process_input(_event: InputEvent) -> Base_State:
	if parent.is_on_floor() and Input.is_action_just_pressed("jump"):
		return jump_state
	if parent.is_on_wall() and Input.is_action_just_pressed("jump"):
		return jump_state
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			return walk_state
	if !parent.has_dashed and Input.is_action_just_pressed("dash"):
		return dash_state
	if Input.is_action_pressed("hold") and parent.is_wall_holdable():
		parent.snap_to_wall()
		return wall_hold_state
	return null


func _process_physics(_delta: float) -> Base_State:	
	parent.move_and_slide()
	# returns fall state if parent isn't on the floor anymore (breakable platforms)
	if !parent.is_on_floor():
		self.exit()
		return fall_state
	return null
