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
## This will change how much of their horizontal momentum the player takes with them into the jumping state. 
@export_range(0.0, 1.0) var MOMENTUM_MODIFIER: float 

# dash variables
## How far the player dashes in pixels.
@export var DASH_DISTANCE: float
## How fast the player dashes in pixels.
@export var DASH_SPEED: float

# state machine
## This holds the state_machine node that coordinates all states and the player's movement. [br]
## It should be a child of the player node. 
@export var state_machine: Node
## This is the path to the AnimationPlayer Node that performs all animations of the player.
@export var animation_player: AnimationPlayer
## The path to a [RayCast2D] node that is used for the wall_hold ability. 
@export var wall_hold_ray_cast: RayCast2D

#flags
## The direction the player is currently facing.
## Default direction is right 1, left would be -1
var facing_direction: int = 1  
## Is used to determine if the player can jump. 
var has_jumped: bool = true
## Is used to determine if the player can dash.
var has_dashed: bool = false

# Get the gravity from the project settings.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variables for the wall_holding
var can_wall_hold: String = "can_wall_hold"
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


## Function to change the player's facing direction
func set_facing_direction(direction: int) -> void:
	if direction < 0:
		direction = -1
		facing_direction = direction
	elif direction > 0: 
		direction = 1
		facing_direction = direction
	else: 
		push_warning("facing direction mustn't be zero!")


##Function that returns custom data from collided tile to determine if the player can wall hold on the tile.
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

## Function that moves the player towards the wall they are facing.
func snap_to_wall() -> void:
	while (!is_on_wall()):
		velocity.x = 5*facing_direction
		move_and_slide()
