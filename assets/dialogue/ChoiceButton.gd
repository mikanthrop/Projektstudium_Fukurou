class_name ChoiceButton extends Button

signal choice_selected(choice_index: int)

var choice_index: int

func _on_pressed():
	choice_selected.emit(choice_index)
