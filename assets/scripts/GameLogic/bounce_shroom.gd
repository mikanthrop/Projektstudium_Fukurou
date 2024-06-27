extends Area2D

## multiplier for the movement speed of the player. 
## influences jump_height. Default ist 1.5
@export var movement_multiplier: float = 1.5;
## jump_direction dictates the direction of the bounce shroom by using a vector2.
## please only use vector2 (0,-1) or (0,1). Default ist upwards
@export var jump_direction: Vector2 = Vector2.UP

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var animation_name: StringName = "bounce"


func _on_body_entered(body):
	## check if body entered is player (via name)
	if body is Player:
		var player: Player = owner.get_node_or_null(NodePath(body.name))
		
		if player: 
			animation_player.play(animation_name)
			## instantiate y coordinate of jump_velocity
			var jump_velocity: float = calculate_jump_velocity(player)
			
			## set player upward velocity to the jump_velocity times movement_multiplier
			player.velocity = jump_direction * jump_velocity * movement_multiplier 
			player.move_and_slide()
			print("player velocity bounce shroom: ", jump_direction, " * ", jump_velocity, " * ", movement_multiplier, " = ", player.velocity)


## calculates jump_velocity based on jump_direction 
func calculate_jump_velocity(player: Player) -> float: 
	## upwards bounce
	var jump_velocity: float;
	if jump_direction == Vector2.UP:
		jump_velocity = ((2.0 * player.JUMP_HEIGHT) / player.JUMP_TIME_TO_PEAK)
		print("bounce shroom: ", jump_velocity)
	
	## downwards bounce
	elif jump_direction == Vector2.DOWN:
		jump_velocity = ((2.0 * player.JUMP_HEIGHT) / player.JUMP_TIME_TO_PEAK)
		print("bounce shroom: ", jump_velocity)
	
	## no implemented jump_direction used
	else: 
		push_error("jump_direction isn't a valid direction. only supports (0,-1) and (0,1).")
		jump_velocity = 0
	return jump_velocity
