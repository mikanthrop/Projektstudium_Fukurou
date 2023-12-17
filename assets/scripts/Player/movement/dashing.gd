extends Base_State


func enter():
	super()
	print("changed state to dashing")
	parent.has_dashed = true

func exit() -> void: 
	print("state dashing: exit")

func process_input(_event: InputEvent) -> Base_State: 
	print("state dashing: process input ", _event)
	return null

func _process_physics(delta: float) -> Base_State:
	print("state dashing: process physics")
	return null

func process_frame(delta: float) -> Base_State: 
	return null
