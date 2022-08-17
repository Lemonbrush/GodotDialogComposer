extends Node

var default_save_path = "res://Exports"
var SAVE_DIR

var preferences_directory = "res://Preferences_save"
var preferences_file_path = "/preferences.json"

func _ready():
	var saved_file_path = get_saved_file_path()
	update_path_variables(saved_file_path)

func update_path_variables(saved_file_path):
	if saved_file_path == null:
		SAVE_DIR = default_save_path
	else:
		SAVE_DIR = saved_file_path

func set_new_save_file_path(new_file_path):
	var data_dictionary = {
		"file_path": new_file_path
	}
	
	prepare_export_directory()
	
	var file = File.new()
	var _is_opened = file.open(preferences_directory + preferences_file_path, File.WRITE)
	file.store_string(to_json(data_dictionary))
	file.close()
	
	update_path_variables(new_file_path)

func get_saved_file_path():
	var path = preferences_directory + preferences_file_path
	var file = File.new()
	file.open(path, File.READ);
	var json_obj = JSON.parse(file.get_as_text()).result
	file.close() 
	
	if json_obj:
		return json_obj["file_path"]

func prepare_export_directory():
	var dir = Directory.new()
	if !dir.dir_exists(preferences_directory):
		dir.make_dir_recursive(preferences_directory)
