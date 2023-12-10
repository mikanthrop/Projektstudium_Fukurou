extends Base_State

@export var coyote_timer: Timer

#var jump_height: float = jump_state.jump_height
@export var jump_time_to_descent: float

@onready var FALL_GRAVITY: float =  (-1) * ((-2 * jump_state.jump_height) / (jump_time_to_descent * jump_time_to_descent))

func enter() -> void: 
	super()
	print("changed state to falling")


func process_input(_event: InputEvent) -> Base_State: 
	if Input.is_action_just_pressed("jump"):
		if !coyote_timer.is_stopped(): 
			print("remaining coyote time ",coyote_timer.time_left)
			coyote_timer.stop()
			return jump_state
	return null


func _process_physics(delta: float) -> Base_State: 
	if not parent.is_on_floor():
		parent.velocity.y += FALL_GRAVITY * delta
	
	var movement = Input.get_axis("move_left", "move_right") * (parent.MOVE_SPEED)
	parent.velocity.x = movement
	parent.move_and_slide()
	
	print("state falling: parent velocity at ", parent.velocity.y)
	
	# if player stops falling and moves change state to walking
	if parent.is_on_floor():
		if parent.velocity.x != 0: 
			return walk_state
		if parent.velocity.x == 0: 
			return idle_state
	return null 
