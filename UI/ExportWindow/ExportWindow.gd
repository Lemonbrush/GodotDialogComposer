extends CanvasLayer

onready var fileNameTextField = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/LineEdit
onready var saveButton = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/SaveButton
onready var saved_files_list = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/ItemList
onready var export_text_field = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/ExportFilePathHBox/ExportLineEdit
onready var pathSelectionModeToggleButton = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/SelectionModeButton

var SAVE_DIR = "res://Exports"

var file_list = []
var export_data

func _ready():
	export_text_field.text = SAVE_DIR
	
	if export_data == null:
		saveButton.disabled = true
	
	prepare_export_directory()
	update_save_button_availability()
	update_file_list()

func _on_save_button_pressed():
	save_as_json(export_data, fileNameTextField.text)
	queue_free()

func _on_cancel_button_pressed():
	queue_free()

func _on_text_field_file_name_text_changed(new_text):
	update_save_button_availability()

func _on_file_item_selected(index):
	var new_text = file_list[index]
	
	if pathSelectionModeToggleButton.pressed:
		var last_char = export_text_field.text[export_text_field.text.length() - 1]
		if last_char != "/":
			export_text_field.text = export_text_field.text + "/" + new_text
		else:
			export_text_field.text = export_text_field.text + new_text
		
		update_file_list()
	else:
		var json_substr = new_text.find_last(".json")
		
		if json_substr != -1:
			new_text.erase(json_substr, new_text.length())
		
		fileNameTextField.text = new_text
	
	update_save_button_availability()

func _on_export_line_edit_text_changed(new_text):
	update_file_list()

func _on_use_path_as_default_button_pressed():
	pass # Replace with function body.

### Helpers

func update_file_list():
	saved_files_list.clear()
	file_list = list_files_in_directory(export_text_field.text)
	
	for file_name in file_list:
		saved_files_list.add_item(file_name)

func prepare_export_directory():
	var save_dir = export_text_field.text
	var dir = Directory.new()
	if !dir.dir_exists(save_dir):
		dir.make_dir_recursive(save_dir)

func save_as_json(data_dictionary, save_name):
	prepare_export_directory()
	
	var file = File.new()
	var _is_opened = file.open(export_text_field.text + "/" + save_name + ".json", File.WRITE)
	file.store_string(to_json(data_dictionary))
	file.close()

func update_save_button_availability():
	saveButton.disabled = fileNameTextField.text == ""

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
