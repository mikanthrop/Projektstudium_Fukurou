extends Node2D

@onready var part1: Resource = preload("res://assets/screens/Part1.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_go_back_to_start_button_pressed():
	get_tree().change_scene_to_packed(part1)
