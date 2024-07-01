extends Node2D

var player_scene : Resource = preload("res://assets/scenes/prefabs/player.tscn")
var animation_name : String = "despawn"
@onready var death = $death
func _on_death_zone_body_entered(body) -> void:
	body.set_process_unhandled_input(false)
	body.set_physics_process(false)
	body.set_process(false)
	
	if (body.name == "Player"):
		
		var player: Player = owner.get_node_or_null(NodePath(body.name))
		
		# Disable player movement
		# search for animation player
		var children : Array[Node] = player.get_children()
		var animation_player : AnimationPlayer
		for child in children: 
			if child.name == "FukuAnimation":
				animation_player = child
				break
		if animation_player != AnimationPlayer:
			# player despawn animation
			death.play()
			print("Animation player playing death animation")
			animation_player.play(animation_name)
			# wait for a specific amount of time
			await animation_player.animation_finished
			# Reset Player's transform and enable player movement
			player.global_position = self.global_position
			body.set_process(true)
			body.set_physics_process(true)
			body.set_process_unhandled_input(true)
