extends Base_State

class_name Wall_Hold_State

var pos: Vector2
@onready var holding = $holding
func enter() -> void: 
	super()
	holding.play()
	print("changed state to wall_holding")
	pos = parent.get_position_delta()
	print("all holding at position: ", pos)


func exit() -> void:
	parent.velocity.y = 0


func process_input(_event: InputEvent) -> Base_State: 
	if Input.is_action_just_pressed('jump'):
		return jump_state
	elif Input.is_action_just_pressed("dash") and !parent.has_dashed:
		return dash_state
	while Input.is_action_pressed('hold') and parent.is_on_wall():
		return null
	return fall_state


func process_frame(_delta: float) -> Base_State:
	animation_name = "wallhold"
	#play animation
	if parent.animation_player.has_animation(animation_name):
		parent.animation_player.play(animation_name)
	return null;
