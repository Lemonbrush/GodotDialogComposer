extends Node

var save_file_resource = Save_file_resource.new()

var SAVE_DIR = "res://Saves"

func save_project(name):
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	# saving logic
	
	var currentScene = get_tree().get_current_scene()
	
	print(currentScene.get_children())
	# we have to make all subNodes to be in the root node in order to let them be packed
	for child in currentScene.get_children():
		if child.has_method("set_owner"):
			child.set_owner(currentScene)
	
	var packedScene = PackedScene.new()
	packedScene.pack(currentScene)
	var lastVisitedSceneName = get_tree().get_current_scene().get_name() 
	save_file_resource.graphScene = packedScene
	
	var error = ResourceSaver.save(SAVE_DIR + "/" + name + ".tres", save_file_resource)
	if error != OK:
		print("Save Error")
	else:
		print("Game saved")

func delete_project_file(project_file_name):
	var dir = Directory.new()
	dir.remove(SAVE_DIR + "/" + project_file_name)

func load_project(project_name):
	save_file_resource = load(SAVE_DIR + "/" + project_name)
	print(save_file_resource.graphScene)
	var _changedScene = get_tree().change_scene_to(save_file_resource.graphScene)
	get_tree().get_current_scene().add_child(Button.new())

### Helpers

func list_files_in_directory(path):
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
