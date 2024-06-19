extends Node2D

var player_scene : Resource = preload("res://assets/scenes/prefabs/player.tscn")
var wait_duration : float = 1.0

func _on_death_zone_body_entered(body) -> void:
	
	if (body.name == "Player"):
		var player: Player = owner.get_node_or_null(NodePath(body.name))
		
		if player:
			# make player invisible
			var children : Array[Node] = player.get_children()
			var sprite : Sprite2D
			for child in children: 
				if child.name == "PlayerSprite":
					sprite = child
					break
			sprite.visible = false
			player.set_process(false)
			player.set_process_unhandled_input(false)
			# wait for a specific amount of time
			await get_tree().create_timer(wait_duration).timeout
			# make player visible again
			sprite.visible = true
			player.set_process(true)
			player.set_process_unhandled_input(true)
			# Reset Player's transform
			player.global_position = self.global_position
