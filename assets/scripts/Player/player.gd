class_name Player
extends CharacterBody2D

# general variables
## How fast the player moves in pixels.
@export var MOVE_SPEED: float

# jump variables
## How high the player can jump at max in pixels.
@export var JUMP_HEIGHT: float
## How long it takes the player to reach the maximum peak of the jump in seconds.
@export var JUMP_TIME_TO_PEAK: float
## How long it takes the player to reach the ground after reaching the peak of the jump in seconds.
@export var JUMP_TIME_TO_DESCENT: float

# dash variables
## How far the player dashes in pixels.
@export var DASH_DISTANCE: float
## How fast the player dashes in pixels.
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
