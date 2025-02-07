extends Area2D

## multiplier for the movement speed of the player. 
## influences jump_height. Default ist 1.5
@export var movement_multiplier: float = 600;
@onready var boing = $boing
## jump_direction dictates the direction of the bounce shroom by using a vector2.
## please only use vector2 (0,-1) or (0,1). Default ist upwards
@export var jump_direction: Vector2 = Vector2.UP ##$facingDirection

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var animation_name: StringName = "bounce"

func _ready():
	var M_rod = Transform2D(Vector2(0,-1),Vector2(1,0),Vector2(0,0))
	M_rod = M_rod.rotated(self.get_rotation())
	print(get_rotation())
	jump_direction = M_rod[0].normalized()
	print(jump_direction)

func _on_body_entered(body):
	## check if body entered is player 
	if body is Player:
		boing.play()
		var player: Player = owner.get_node_or_null(NodePath(body.name))
		
		if player: 
			animation_player.play(animation_name)
			## instantiate y coordinate of jump_velocity
			## var jump_velocity: float = calculate_jump_velocity(player)
			var bounce_vector = jump_direction * movement_multiplier
			player.velocity = bounce_vector
			
			## set player upward velocity to the jump_velocity times movement_multiplier
			## player.velocity = jump_direction * jump_velocity * movement_multiplier 
			player.move_and_slide()
			
		# since the dash_shroom should technically be seen as ground, the 
		# dash_flag and jump_flag should be reset
		if player.get_has_dashed():
			player.set_has_dashed(false)
		if player.get_has_jumped():
			player.set_has_jumped(false)


## calculates jump_velocity based on jump_direction 
func calculate_jump_velocity(player: Player) -> float: 
	## upwards bounce
	var jump_velocity: float;
	if jump_direction == Vector2.UP:
		jump_velocity = ((2.0 * player.JUMP_HEIGHT) / player.JUMP_TIME_TO_PEAK)
		## jump_velocity = 2.0 * 220.58823529411764705882352941176
	## downwards bounce
	elif jump_direction == Vector2.DOWN:
		jump_velocity = ((2.0 * player.JUMP_HEIGHT) / player.JUMP_TIME_TO_PEAK)
	
	## Leftside bounce
	elif jump_direction == Vector2.LEFT:
		jump_velocity = ((18.0 * player.JUMP_HEIGHT) / player.JUMP_TIME_TO_PEAK)
	
	## Rightside bounce
	elif jump_direction == Vector2.RIGHT:
		## Ideas: Disable Gravit/Bounce slighly upwards
		jump_velocity = ((16.0 * player.JUMP_HEIGHT) / player.JUMP_TIME_TO_PEAK)
	
	## no implemented jump_direction used
	else: 
		push_error("jump_direction isn't a valid direction. only supports (0,-1) and (0,1).")
		jump_velocity = 0
	return jump_velocity
		

