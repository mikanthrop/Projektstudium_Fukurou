extends Area2D
class_name TransitionArea

## Takes the an Array of [param CollisionShape2D] of the current screen, and all the screens the player can go from there. 
@export var screen_limits: Array[CollisionShape2D];

var player_pos: Vector2 = Vector2.ZERO
var camera: PhantomCamera2D

## transition logic
func _on_body_exited(body):
	if body is Player:
		player_pos = body.global_position
		camera = body.get_node("PhantomCamera2D")
		#
		## splits path to make comparison between paths possible
		#var pre_limit: PackedStringArray = str(this_screen_limit.get_path()).split("/")
		#var next_limit: PackedStringArray = str(next_screen_limit.get_path()).split("/")
		#var current_limit: PackedStringArray = str(camera.limit_target).split("/")
		#
		##if current limit is this_screen_limit change to next_screen_limit
		#if current_limit[-1] == pre_limit[-1] and current_limit[-2] == pre_limit[-2]: 
			#print("camera limit changed to next screen")
			#camera.set_limit_target(next_screen_limit.get_path())
		##if current limit is next_screen_limit change to this_screen_limit
		#if current_limit[-1] == next_limit[-1] and current_limit[-2] == next_limit[-2]: 
			#print("camera limit changed to previous screen")
			#camera.set_limit_target(this_screen_limit.get_path())
			#

## TODO: Check if player is still visible on screen after exiting the transition area
## TIPP: Use the OnScreenNotifier of Player for this
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# wait until player_pos has been updated
	while(player_pos==Vector2.ZERO):
		await get_tree().create_timer(0.1).timeout
	
	# run through the screen limit array to find the rectangle that contains the updated point of player
	for limit in screen_limits: 
		if !limit.shape.get_rect().has_area():
			push_error("% has no area!" % limit)
			break
		# check if the player is inside the limit
		if player_pos != Vector2.ZERO:
			if limit.shape.get_rect().has_point(player_pos):
				camera.set_limit_target(limit.get_path())
		## if not, continue searching
		

