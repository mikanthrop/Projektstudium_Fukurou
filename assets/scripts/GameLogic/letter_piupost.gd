extends Sprite2D

class_name Letter

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var idle_anim_name: StringName = "idle"
var collect_anim_name: StringName = "collect"

# Called when the node enters the scene tree for the first time.
func _ready():
	# play idle letter animation
	animation_player.play(idle_anim_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body is Player: 
		# play collect letter animation
		animation_player.play(collect_anim_name)
		# add one to autoload script
		TrackingCollectables.add_letter()
		# play letter already collected animation
