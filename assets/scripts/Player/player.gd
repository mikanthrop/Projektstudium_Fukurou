class_name Player
extends CharacterBody2D

# general variables
@export var MOVE_SPEED: float

# jump variables
@export var JUMP_HEIGHT: float
@export var JUMP_TIME_TO_PEAK: float
@export var JUMP_TIME_TO_DESCENT: float

# dash variables
@export var DASH_DISTANCE: float
@export var DASH_SPEED: float

# state machine
@export var state_machine: Node

#flags
var facing_direction: int = 1  # Default direction is right 1, left would be -1
var was_on_floor: bool = true
var has_dashed: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# initialize state_machine on boot
func _ready():
	print_tree_pretty()
	state_machine.init(self)

# give input to state_machine
func _unhandled_input(event):
	state_machine.process_input(event)

# give physicy handling to state machine
func _physics_process(delta):
	state_machine._process_physics(delta)


# give other processing to state machine
func _process(delta): 
	state_machine.process_frame(delta)


# Function to change the facing direction
func set_facing_direction(direction: int) -> void:
	if direction < 0:
		direction = -1
		facing_direction = direction
	elif direction > 0: 
		direction = 1
		facing_direction = direction
	else: 
		push_warning("facing direction mustn't be zero!")
