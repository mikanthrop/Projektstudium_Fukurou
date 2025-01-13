extends Area2D

@onready var boing = $boing
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var shroom_dash_direction: Vector2
var dashing: Base_State

# Gets the rotation from the sprite and normalizes its direction to use for the 
# dash direction when the player comes in contact with the Area2D
func _ready():
	var sprite_rotation = Transform2D(Vector2(0,-1),Vector2(1,0),Vector2(0,0))
	sprite_rotation = sprite_rotation.rotated(self.get_rotation())
	shroom_dash_direction = sprite_rotation[0].normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# player dashes upon area2D entry without setting the dash flag. Therefore we try
# to invoke the dash state from this method.
func _on_body_entered(body):
	
	if body is Player:
		# TODO setting sounds to play as soon as sounds are available
		
		var player: Player = owner.get_node_or_null(NodePath(body.name))
		
		# since the dash_shroom should technically be seen as ground, the 
		# dash_flag and jump_flag should be reset
		if player.get_has_dashed():
			player.set_has_dashed(false)
		if player.get_has_jumped():
			player.set_has_jumped(false)
		
		# set the instance of the Dash_State that is already a child of the state_
		# machine as the instance we want to confer to when inducing the dash_state
		dashing = player.state_machine.get_node("dashing")
		dashing.set_dash_direction(shroom_dash_direction)
		print(dashing.get_dash_direction())
		
		if player:
				# TODO set animations to play as soon as they are available
				player._change_state(dashing)
