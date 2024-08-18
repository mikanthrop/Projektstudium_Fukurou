extends Node2D

@onready var death = $death

var player_scene : Resource = preload("res://assets/prefabs/player.tscn")
var animation_name : String = "despawn"

func _on_death_zone_body_entered(body) -> void:
	# Disable player movement
	body.set_process_unhandled_input(false)
	body.set_physics_process(false)
	body.set_process(false)
	
	if body is Player:
		var player: Player = body as Player
		
		# search for animation player
		var animation_player : AnimationPlayer = player.get_node_or_null("FukuAnimation")
		if animation_player:
			# Play death animation
			death.play()
			animation_player.play(animation_name)
			# wait for a specific amount of time
			await animation_player.animation_finished
			# Reset Player's transform and enable player movement
			player.global_position = self.global_position
			player.velocity = Vector2(0,0);
			print("in respawner: reset player's position")
			await get_tree().create_timer(0.1).timeout
	
	# restart player methods
	body.set_process(true)
	body.set_physics_process(true)
	body.set_process_unhandled_input(true)
		


func _on_death_zone_6_body_entered(body):
	pass # Replace with function body.


func _on_death_zone_3_body_entered(body):
	pass # Replace with function body.


func _on_death_zone_2_body_entered(body):
	pass # Replace with function body.


func _on_death_zone_4_body_entered(body):
	pass # Replace with function body.


func _on_death_zone_5_body_entered(body):
	pass # Replace with function body.


func _on_death_zone_7_body_entered(body):
	pass # Replace with function body.


func _on_death_zone_8_body_entered(body):
	pass # Replace with function body.


func _on_death_zone_9_body_entered(body):
	pass # Replace with function body.
