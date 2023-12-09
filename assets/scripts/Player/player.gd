class_name Player
extends CharacterBody2D


@export var MOVE_SPEED: float = 100.0
@export var JUMP_VELOCITY = 400.0

@export var state_machine: Node

#flags
var has_jumped = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	print_tree_pretty()
	state_machine.init(self)

func _unhandled_input(event):
	state_machine.process_input(event)

func _physics_process(delta):
	state_machine._process_physics(delta)
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("move_left", "move_right")
#	if direction:
#		velocity.x = direction * MOVE_SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
#
#	move_and_slide()
	
func _process(delta): 
	state_machine.process_frame(delta)
