extends Node


func write_to_dict(file_path: String, json_string: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE) 
	file.store_line(json_string)
	pass


func read_from_dict(file_path: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var dict: Dictionary = Dictionary()
	# load the file line by line and process the dictionary
	while not file.eof_reached():
		var jsn_string: String = file.get_line()
		# helper class to interact with JSON
		var json: JSON = JSON.new()
		# check for errors while parsing jsn_string and skip in case of failure
		var parse_result = json.parse(jsn_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", jsn_string, " at line ", json.get_error_line())
			continue
		var data = json.get_data()
		print(data)
	return dict
		


func create_trackables_dict() -> void:
	const trackables_dict_path: String = "res://assets/dialogue/dictionary/trackables_dict.json"
	var data: Dictionary = {
		"letters": TrackingCollectables.get_collected_letters(), 
		"all_letters": TrackingCollectables.get_all_letters_collected()}
	var json_str: String = JSON.stringify(data)
	write_to_dict(trackables_dict_path, json_str)

