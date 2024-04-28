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
var can_wall_hold = "can_wall_hold"


# initialize state_machine on boot
func _ready() -> void:
	print_tree_pretty()
	state_machine.init(self)


# give input to state_machine
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)


# give physicy handling to state machine
func _physics_process(delta: float) -> void:
	state_machine._process_physics(delta)


# give other processing to state machine
func _process(delta: float) -> void: 
	state_machine.process_frame(delta)


# returns custom data from collided tile
func is_wall_holdable() -> bool:
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision: 
		var collider: Object = collision.get_collider()
		if collider.is_class("TileMap"):
			var tile_pos: Vector2i = collider.local_to_map(collision.get_position())
			var tile_data: TileData = collider.get_cell_tile_data(0, tile_pos)
			if tile_data.get_custom_data(can_wall_hold):
				return true
	return false


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
