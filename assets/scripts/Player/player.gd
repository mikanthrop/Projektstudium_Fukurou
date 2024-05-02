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
@export var animation_player: AnimationPlayer
@export var wall_hold_ray_cast: RayCast2D

#flags
var facing_direction: int = 1  # Default direction is right 1, left would be -1
var was_on_floor: bool = true
var has_dashed: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# raycasts for wall holding
var can_wall_hold = "can_wall_hold"
var raycast_length: int = 13


# initialize state_machine on boot
func _ready() -> void:
	print_tree_pretty()
	state_machine.init(self)


# give input to state_machine
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)


# give physicy handling to state machine
func _physics_process(delta: float) -> void:
	wall_hold_ray_cast.target_position.x = facing_direction*raycast_length
	state_machine._process_physics(delta)


# give other processing to state machine
func _process(delta: float) -> void: 
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


# returns custom data from collided tile
func is_wall_holdable() -> bool:
	if wall_hold_ray_cast.is_colliding():
		var collider: Object = wall_hold_ray_cast.get_collider()
		if collider.is_class("TileMap"):
			var collision_pos: Vector2i = wall_hold_ray_cast.get_collision_point()
			var tile_pos : Vector2 = collider.local_to_map(collision_pos)
			var tile_data: TileData = collider.get_cell_tile_data(0, tile_pos, true)
			if tile_data == null:
				print("wall isn't holdable")
				return false
			elif tile_data.get_custom_data(can_wall_hold):
				print("wall is holdable")
				return true 
	print("wall isn't holdable")
	return false


func snap_to_wall() -> void:
	while (!is_on_wall()):
		velocity.x = 5*facing_direction
		move_and_slide()
