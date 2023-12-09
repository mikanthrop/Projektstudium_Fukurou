extends Base_State


@export var idle_state: Base_State
@export var walk_state: Base_State
@export var jump_state: Base_State

@onready var coyote_timer: Timer = get_node("../../CoyoteTimer")

func enter() -> void: 
	super()
	
	# checks for coyote timer if player has jumped
	if not parent.has_jumped:
		coyote_timer.start()
	print("changed state to falling")
	
	
func process_input(_event: InputEvent) -> Base_State: 
	if coyote_timer.time_left > 0 and Input.is_action_just_pressed("jump"):
		coyote_timer.stop()
		return jump_state
	return null
	
	
func _process_physics(delta: float) -> Base_State: 
	if not parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("move_left", "move_right") * move_speed
	parent.velocity.x = movement
	parent.move_and_slide()
	
	print("state falling: parent velocity at ", parent.velocity.y)
	
	# if player stops falling and moves change state to walking
	if parent.is_on_floor() and parent.velocity.x != 0: 
		return walk_state
	# if player stops falling and doesn't move change state to idle
	if parent.is_on_floor() and parent.velocity.x == 0:
		return idle_state
	return self 
