extends Node

signal project_loaded(project_data)
signal project_name_changed(new_name)

var main_scene_path = "res://MainScene/Control.tscn"
var current_project_name = "New_project"

func save(data_dictionary):
	prepare_export_directory()
	
	var file = File.new()
	var _is_opened = file.open(PreferencesManager.SAVE_DIR + "/" + current_project_name + ".json", File.WRITE)
	file.store_string(to_json(data_dictionary))
	file.close()
	
	emit_signal("project_name_changed", current_project_name)

func shortcut_save(data_dictionary):
	save(data_dictionary)
	
func load_project(project_name):
	var path = PreferencesManager.SAVE_DIR + "/" + project_name
	var file = File.new()
	file.open(path, File.READ);
	var json_obj = JSON.parse(file.get_as_text()).result
	file.close()
	
	emit_signal("project_loaded", json_obj)
	
	setup_current_project_name(project_name)

func setup_current_project_name(project_name):
	var json_substr = project_name.find_last(".json")
	if json_substr != -1:
		project_name.erase(json_substr, project_name.length())
	
	current_project_name = project_name
	emit_signal("project_name_changed", current_project_name)

func delete_project_file(project_file_name):
	var dir = Directory.new()
	dir.remove(PreferencesManager.SAVE_DIR + "/" + project_file_name)

### Helpers

func prepare_export_directory():
	var dir = Directory.new()
	if !dir.dir_exists(PreferencesManager.SAVE_DIR):
		dir.make_dir_recursive(PreferencesManager.SAVE_DIR)

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
