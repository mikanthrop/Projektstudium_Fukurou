extends Node

var tracked_letters = {
	"max_letter_number": 8,
	"collected_letters": 0,
	"all_letters_collected": false
}


func add_letter() -> void:
	tracked_letters["collected_letters"] = tracked_letters["collected_letters"] + 1
	print("collected a letter. Now ", tracked_letters["collected_letters"], " have been collected.")
	check_all_letters_collected()


func check_all_letters_collected() -> void:
	if (tracked_letters["collected_letters"] == tracked_letters["max_letter_number"]):
		tracked_letters["all_letters_collected"] = true


func get_tracked_letters() -> Dictionary: 
	return tracked_letters
