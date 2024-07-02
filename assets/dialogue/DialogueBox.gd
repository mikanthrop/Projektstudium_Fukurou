extends Node2D

@onready var choice_button_scn = preload("res://assets/dialogue/ChoiceButton.tscn")
@onready var display_box: VBoxContainer = $VBoxContainer
@onready var display_label: Label = $VBoxContainer/Text
@onready var ez_dialogue: EzDialogue = $"../EzDialogue"

var choice_buttons: Array[Button] = []


func _ready():
	display_box.set_visible(false)


func clear_dialogue_box():
	display_label.text = ""
	for choice in choice_buttons:
		display_box.remove_child(choice)
	choice_buttons = []


func add_text(text: String):
	display_label.text = text


func add_choice (choice_text: String):
	var button_obj: ChoiceButton = choice_button_scn.instantiate()
	var button_label : Label= button_obj.get_child(0)
	button_obj.choice_index = choice_buttons.size()
	choice_buttons.push_back(button_obj)
	button_label.text = choice_text
	button_obj.choice_selected.connect(_on_choice_selected)
	display_box.add_child(button_obj)


func _on_choice_selected(choice_index: int):
	ez_dialogue.next(choice_index)

