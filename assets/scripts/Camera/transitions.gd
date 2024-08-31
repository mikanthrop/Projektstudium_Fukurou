extends Camera2D


@onready var player: Player = $"../Player"
@onready var cam: PhantomCamera2D = $"../Player/PhantomCamera2D"

var screen_limits: Array[CollisionShape2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children: Array[Node] = get_tree().get_nodes_in_group("camera_limit")
	for child in children: 
		if child is Camera_Limit: 
			screen_limits.append(child)


# When the player leaves the screen, find him in a different one
func _on_visible_on_screen_notifier_2d_screen_exited():
	var index: int = 0
	# search in every screen_limit
	for limit in screen_limits: 
		var shape_rect: Rect2 = limit.get_shape().get_rect()
		
		if !shape_rect.has_area():
			push_error("%s has no area!" % limit.name)
			break
		# check if the player is inside the limit
		if contains_point(limit, player.global_position):
			cam.limit_target = limit.get_path()
		index = index + 1
		## if not, continue searching


func contains_point(shape: CollisionShape2D, point: Vector2): 
	var rect : Rect2 = shape.get_shape().get_rect()
	var start : Vector2 = shape.global_position - Vector2(rect.size.x/2, rect.size.y/2)
	var end : Vector2 = start + rect.size
	
	# If the player is inside the limits
	if start.x < point.x and end.x > point.x:
		if start.y < point.y and end.y > point.y: 
			return true
	return false
