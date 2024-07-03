extends Area2D
class_name TransitionArea

## Takes the [param CollisionShape2D] of the current screen. 
@export var this_screen_limit: CollisionShape2D;
## Takes the [param CollisionShape2D] of the screen to transition to. 
@export var next_screen_limit: CollisionShape2D;

## transition logic
func _on_body_entered(body):
	if body is Player:
		print("player entered transition area")
		var camera: PhantomCamera2D = body.get_node("PhantomCamera2D")
		
		# splits path to make comparison between paths possible
		var pre_limit: PackedStringArray = str(this_screen_limit.get_path()).split("/")
		var next_limit: PackedStringArray = str(next_screen_limit.get_path()).split("/")
		var current_limit: PackedStringArray = str(camera.limit_target).split("/")
		
		#if current limit is this_screen_limit change to next_screen_limit
		if current_limit[-1] == pre_limit[-1] and current_limit[-2] == pre_limit[-2]: 
			print("camera limit changed to next screen")
			camera.limit_target = next_screen_limit.get_path()
		#if current limit is next_screen_limit change to this_screen_limit
		if current_limit[-1] == next_limit[-1] and current_limit[-2] == next_limit[-2]: 
			print("camera limit changed to previous screen")
			camera.limit_target = this_screen_limit.get_path()
