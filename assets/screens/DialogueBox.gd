extends Node2D

@onready var choice_button_scn = preload("res://ChoiceButton.tscn")
@onready var display_box: VBoxContainer = $VBoxContainer
@onready var display_label: Label = $VBoxContainer/Text

var choice_buttons: Array[Button] = []


func _ready():
	add_text("Bat boys, bat boys, what you gonna do, what you gonna do when we come for you?")


func clear_dialogue_box():
	display_box.test = ""
	for choice in choice_buttons:
		display_box.remove_child(choice)
	choice_buttons = []


func add_text(text: String):
	display_label.text = text


func add_choice (choice_text: String):
	var button_obj: ChoiceButton = choice_button_scn.instantiate()
	button_obj.choice_index = choice_buttons.size()
	choice_buttons.push_back(button_obj)
	button_obj.text = choice_text
	button_obj.choice_selected.connect(_on_choice_selected)
	display_box.add_child(button_obj)


func _on_choice_selected(choice_index: int):
	print(choice_index)
	pass


func _on_ez_dialogue_dialogue_generated(response: DialogueResponse):
	add_text(response.text)
	for choice in response.choices:
		add_choice(choice)
	pass # Replace with function body.
