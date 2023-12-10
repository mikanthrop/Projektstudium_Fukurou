class_name Player
extends CharacterBody2D


@export var MOVE_SPEED: float

@export var state_machine: Node

#flags
var was_on_floor

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	print_tree_pretty()
	state_machine.init(self)


func _unhandled_input(event):
	state_machine.process_input(event)


func _physics_process(delta):
	state_machine._process_physics(delta)


func _process(delta): 
	state_machine.process_frame(delta)
