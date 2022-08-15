extends CanvasLayer

onready var fileNameTextField = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/LineEdit
onready var saved_files_list = $MarginContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/SavedFilesList
onready var saveButton = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/SaveButton
onready var deleteModeButton  = $MarginContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/DeleteModeButton

var file_list = []

func _ready():
	fileNameTextField.text = SaveFileManager.save_file_resource.project_name
	update_file_list()
	update_save_button_availability()

### Actions

func _on_save_button_pressed():
	SaveFileManager.save_project(fileNameTextField.text)
	queue_free()

func _on_cancel_button_pressed():
	queue_free()

func _on_saved_files_list_item_selected(index):
	var new_text = file_list[index]
	
	if deleteModeButton.pressed:
		SaveFileManager.delete_project_file(new_text)
		update_file_list()
	else:
		var json_substr = new_text.find_last(".tres")
			
		if json_substr != -1:
			new_text.erase(json_substr, new_text.length())
				
		fileNameTextField.text = new_text

func _on_line_edit_text_changed(new_text):
	update_save_button_availability()

### Helpers

func update_save_button_availability():
	saveButton.disabled = fileNameTextField.text == ""

func update_file_list():
	saved_files_list.clear()
	file_list = SaveFileManager.list_files_in_directory(SaveFileManager.SAVE_DIR)
	
	for file_name in file_list:
		saved_files_list.add_item(file_name)
