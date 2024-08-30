extends Node2D

@export var dialogue_json: JSON
@export var dialogue_style: Theme
@export var dialogue_variables: Dictionary
@export var updatable: bool = false

@onready var dialogue_box: Node2D = $DialogueBox
@onready var ez_dialogue: EzDialogueReader = $EzDialogue
@onready var dialogue_layout : VBoxContainer = $DialogueBox/VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not updatable: 
		ez_dialogue.start_dialogue(dialogue_json, TrackingCollectables.get_tracked_letters())
	dialogue_layout.theme = dialogue_style


func _on_ez_dialogue_dialogue_generated(response: DialogueResponse) -> void:
	dialogue_box.clear_dialogue_box()
	
	dialogue_box.add_text(response.text)
	for choice in response.choices:
		dialogue_box.add_choice(choice)


func _on_area_2d_body_entered(body):
	if body is Player: 
		if updatable: 
			ez_dialogue.start_dialogue(dialogue_json, TrackingCollectables.get_tracked_letters())
		dialogue_layout.set_visible(true)


func _on_area_2d_body_exited(body):
	if body is Player: 
		dialogue_layout.set_visible(false)



func _on_ez_dialogue_end_of_dialogue_reached():
	print("Dialogue ended!")
	print("Dialogue path: ", dialogue_json.resource_path)
	var mystra_dialogue: String = "res://assets/dialogue/json/mystra_intro.json"
	if dialogue_json.resource_path == mystra_dialogue: 
		load("res://assets/screens/Mystra_Picture.tscn")
