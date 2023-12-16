extends Node

@export var starting_state: Base_State
var current_state: Base_State


# Initialize the state machine by giving each child state a reference to the 
# parent object it belongs to and enter the default starting_state.
func init(_parent: Player) -> void: 
#	for child in get_children():
#		#print(child.name)
#		if child is Base_State:
#			child.parent = _parent
	
	# Initialize to the default state
	change_state(starting_state)


# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: Base_State) -> void: 
	if current_state: 
		current_state.exit()
	var parent = get_parent()
	print("State Machine gives event to ", new_state, ".")
	current_state = new_state
	current_state.enter()


# Pass input 
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)


# Pass through functions for the Player to call, 
# handling state changes as needed.
func _process_physics(delta: float) -> void:
	var new_state = current_state._process_physics(delta)
	if new_state: 
		change_state(new_state)


func process_frame(delta: float) -> void: 
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
