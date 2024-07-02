extends Node2D

@export var try_json :JSON
@onready var state = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	($EzDialogue as EzDialogue).start_dialogue(try_json, state)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_ez_dialogue_dialogue_generated(response):
	$DialogueBox.add_text(response.text)
	
	
	
	for choice in response.choices:
		$DialogueBox.add_choice(choice)
