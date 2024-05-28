extends Area2D
class_name TransitionArea

## Takes a [param CollisionShape2D] for setting the limits of the new screen the camera will be in. 
@export var screen_limit: CollisionShape2D;

## transition logic
func _on_body_entered(body):
	if (body.name == "Player"):
		print("player entered transition area")
		var camera: PhantomCamera2D = body.get_node("PhantomCamera2D")
		print("camera limit target: ", camera.limit_target)
		print("new screen limit: ", screen_limit.get_path())
		camera.limit_target = screen_limit.get_path()
