extends CanvasLayer

onready var fileNameTextField = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/LineEdit
onready var saveButton = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/SaveButton
onready var saved_files_list = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/ItemList
onready var export_text_field = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/ExportFilePathHBox/ExportLineEdit
onready var pathSelectionModeToggleButton = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/SelectionModeButton
onready var fileDeletionModeToggleButton = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/DeleteModeButton
onready var usePathAsDefaultButton = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/ExportFilePathHBox/UsePathAsDefaultButton
onready var resetPathButton = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/ExportFilePathHBox/ResetButton

var last_selected_file_index

var file_list = []
var export_data

func _ready():
	fileNameTextField.text = SaveFileManager.current_project_name
	export_text_field.text = PreferencesManager.SAVE_DIR
	
	if export_data == null:
		saveButton.disabled = true
	
	update_save_button_availability()
	update_file_list()
	check_reset_path_availability()

func _on_save_button_pressed():
	save()

func _on_cancel_button_pressed():
	queue_free()

func _on_text_field_file_name_text_changed(_new_text):
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
	elif fileDeletionModeToggleButton.pressed:
		SaveFileManager.delete_project_file(new_text)
		update_file_list()
	else:
		if last_selected_file_index == index:
			save()
		else:
			last_selected_file_index = index
			var json_substr = new_text.find_last(".json")
			
			if json_substr != -1:
				new_text.erase(json_substr, new_text.length())
			
			fileNameTextField.text = new_text
	
	update_save_button_availability()

func _on_export_line_edit_text_changed(_new_text):
	update_file_list()
	check_reset_path_availability()
	
func _on_use_path_as_default_button_pressed():
	PreferencesManager.set_new_save_file_path(export_text_field.text)
	check_reset_path_availability()

### Helpers

func check_reset_path_availability():
	usePathAsDefaultButton.disabled = export_text_field.text == PreferencesManager.SAVE_DIR || export_text_field.text == ""
	resetPathButton.disabled = export_text_field.text == PreferencesManager.default_save_path

func save():
	SaveFileManager.setup_current_project_name(fileNameTextField.text)
	SaveFileManager.save(export_data)
	queue_free()

func update_file_list():
	saved_files_list.clear()
	file_list = SaveFileManager.list_files_in_directory(export_text_field.text)
	
	for file_name in file_list:
		saved_files_list.add_item(file_name)

func update_save_button_availability():
	saveButton.disabled = fileNameTextField.text == ""

func _on_delete_mode_button_pressed():
	pathSelectionModeToggleButton.pressed = false

func _on_selection_mode_button_pressed():
	fileDeletionModeToggleButton.pressed = false

func _on_reset_path_button_pressed():
	export_text_field.text = PreferencesManager.default_save_path
	check_reset_path_availability()
	update_file_list()
