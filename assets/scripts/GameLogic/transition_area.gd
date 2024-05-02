extends Node2D

@export var scene_to_transition_to: PackedScene;
var scene_tree: SceneTree;

func ready():
	pass

func _on_body_entered(_body):
	print("I entered.")
	scene_tree = get_tree()
	scene_tree.change_scene_to_packed(scene_to_transition_to)
