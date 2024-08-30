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
			print(child, " has been appended to screen_limits array")


func _on_visible_on_screen_notifier_2d_screen_exited():
	print("player left screen!")
	var index: int = 0
	for limit in screen_limits: 
		print("searching for player in limit ", index)
		var shape_rect: Rect2 = limit.get_shape().get_rect()
		#var shape_recti: Rect2i = Rect2i(shape_rect)
		
		#print("player position: ", player.global_position)
		#print("limit position: ", limit.global_position)
		#print("limit dimensions: ", shape_recti.size)
		print("limit has position of player: ", shape_rect.has_point(player.position))
		print("limit contains position of player: ", contains_point(limit, player.global_position))
		
		if !shape_rect.has_area():
			push_error("%s has no area!" % limit.name)
			break
		# check if the player is inside the limit
		if contains_point(limit, player.global_position):
			print("limit ", index, " contains the player")
			cam.limit_target = limit.get_path()
		index = index + 1
		## if not, continue searching


func contains_point(shape: CollisionShape2D, point: Vector2): 
	var rect : Rect2 = shape.get_shape().get_rect()
	var start : Vector2 = shape.global_position - Vector2(rect.size.x/2, rect.size.y/2)
	var end : Vector2 = start + rect.size
	
	print("global position of limit start: ", start)
	print("global position of limit end: ", end)
	
	if start.x < point.x and end.x > point.x:
		print("point is inside x range")
		if start.y < point.y and end.y > point.y: 
			print("point is inside y range")
			return true
	return false
