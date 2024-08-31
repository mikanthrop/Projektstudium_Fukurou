class_name Base_State
extends Node

@export var idle_state: Base_State
@export var walk_state: Base_State
@export var jump_state: Base_State
@export var fall_state: Base_State
@export var dash_state: Base_State
@export var wall_hold_state: Base_State
# animation_name variable
## Hold a reference to the parent so that it can be controlled by the state
@export var parent: Player
# get animation player so all child states can use it
@onready var animation_name: String

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> Base_State:
	return null

func _process_physics(_delta: float) -> Base_State:
	return null
	
func process_frame(_delta: float) -> Base_State:
	return null
