extends Node

var SAVE_DIR = "res://Saves"
var save_name = "Dialog.json"
var save_path = SAVE_DIR + "/" + save_name

func save_as_json(data_dictionary):
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var _is_opened = file.open(save_path, File.WRITE)
	file.store_string(to_json(data_dictionary))
	file.close()
