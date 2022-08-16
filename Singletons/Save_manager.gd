extends Node

signal project_loaded(project_data)

var main_scene_path = "res://MainScene/Control.tscn"
var save_file_resource = Save_file_resource.new()
var SAVE_DIR = "res://Exports"

func save(save_name, data_dictionary):
	prepare_export_directory()
	
	data_dictionary["dialog_name"] = save_name
	
	var file = File.new()
	var _is_opened = file.open(SAVE_DIR + "/" + save_name + ".json", File.WRITE)
	file.store_string(to_json(data_dictionary))
	file.close()

func shortcut_save(data_dictionary):
	save("default_name", data_dictionary)
	
func load_project(project_name):
	var path = SAVE_DIR + "/" + project_name
	var file = File.new()
	file.open(path, File.READ);
	var json_obj = JSON.parse(file.get_as_text()).result
	file.close()
	
	emit_signal("project_loaded", json_obj)

func delete_project_file(project_file_name):
	var dir = Directory.new()
	dir.remove(SAVE_DIR + "/" + project_file_name)

### Helpers

func prepare_export_directory():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

func list_files_in_directory(path):
	prepare_export_directory()
	
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
