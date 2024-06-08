extends Node2D


func _on_death_zone_body_entered(body) -> void:
	
	if (body.name == "Player"):
		var player: Player = owner.get_node_or_null(NodePath(body.name))
		
		if player:
			# Reset Player's transform
			player.global_position = self.global_position


func _on_death_zone_22_body_entered(body):
	pass # Replace with function body.
