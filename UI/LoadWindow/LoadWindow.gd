extends CanvasLayer

onready var available_projects_list = $MarginContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/AvailableProjectsList

var selected_item_index
var file_list = []

func _ready():
	update_file_list()

func _on_cancel_button_pressed():
	queue_free()

func _on_available_projects_list_item_selected(index):
	if selected_item_index == index:
		SaveFileManager.load_project(file_list[index])
		queue_free()
	else:
		selected_item_index = index

func update_file_list():
	available_projects_list.clear()
	file_list = SaveFileManager.list_files_in_directory(SaveFileManager.SAVE_DIR)
	
	for file_name in file_list:
		available_projects_list.add_item(file_name)
