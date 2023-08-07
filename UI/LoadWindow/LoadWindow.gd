extends CanvasLayer

onready var available_projects_list = $MarginContainer/Panel/MarginContainer/VBoxContainer/AvailableProjectsList
onready var search_line_edit = $MarginContainer/Panel/MarginContainer/VBoxContainer/SearchHBoxContainer/SearchLineEdit

var selected_item_index
var file_list = []

func _ready():
	_reset_list()

func _on_cancel_button_pressed():
	queue_free()

func _on_available_projects_list_item_selected(index):
	if selected_item_index == index:
		SaveFileManager.load_project(file_list[index])
		queue_free()
	else:
		selected_item_index = index

func _reset_list():
	file_list = SaveFileManager.list_files_in_directory(PreferencesManager.SAVE_DIR)
	_update_list()

func _on_reset_search_button_pressed():
	search_line_edit.text = ""
	_reset_list()

func _on_search_line_edit_text_changed(new_text):
	if new_text == "":
		_reset_list()
		return
	
	available_projects_list.clear()
	file_list.clear()
	var actual_file_list = SaveFileManager.list_files_in_directory(PreferencesManager.SAVE_DIR)
	for file_name in actual_file_list:
		if file_name.find(search_line_edit.text) != -1:
			file_list.append(file_name)
	_update_list()

func _update_list():
	available_projects_list.clear()
	for file_name in file_list:
		available_projects_list.add_item(file_name)
