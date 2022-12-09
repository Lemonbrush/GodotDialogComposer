extends CanvasLayer

onready var exportLineEdit = $MarginContainer/Panel/MarginContainer/VBoxContainer/ExportFilePathHBox/ExportLineEdit
onready var saveButton = $MarginContainer/Panel/MarginContainer/VBoxContainer/FileNameHBox/SaveButton
onready var saved_files_list = $MarginContainer/Panel/MarginContainer/VBoxContainer/ItemList
onready var projectNameLineEdit = $MarginContainer/Panel/MarginContainer/VBoxContainer/FileNameHBox/ProjectNameLineEdit
onready var pathSelectionModeToggleButton = $MarginContainer/Panel/MarginContainer/VBoxContainer/FileSelectionModeHBox/SelectionModeButton
onready var fileDeletionModeToggleButton = $MarginContainer/Panel/MarginContainer/VBoxContainer/FileSelectionModeHBox/DeleteModeButton
onready var usePathAsDefaultButton = $MarginContainer/Panel/MarginContainer/VBoxContainer/ExportFilePathHBox/UsePathAsDefaultButton
onready var resetPathButton = $MarginContainer/Panel/MarginContainer/VBoxContainer/ExportFilePathHBox/ResetButton

var last_selected_file_index

var file_list = []
var export_data
var project_name = "Project_name"

func _ready():
	projectNameLineEdit.text = project_name
	exportLineEdit.text = PreferencesManager.SAVE_DIR

	if export_data == null:
		saveButton.disabled = true
	
	update_save_button_availability()
	update_file_list()
	check_reset_path_availability()
	selection_mode_toggle(true)

func _on_save_button_pressed():
	save()

func _on_cancel_button_pressed():
	queue_free()

func _on_text_field_file_name_text_changed(_new_text):
	update_save_button_availability()

func _on_file_item_selected(index):
	var new_text = file_list[index]
	
	if pathSelectionModeToggleButton.pressed:
		var last_char = exportLineEdit.text[exportLineEdit.text.length() - 1]
		if last_char != "/":
			exportLineEdit.text = exportLineEdit.text + "/" + new_text
		else:
			exportLineEdit.text = exportLineEdit.text + new_text
		
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
			
			exportLineEdit.text = new_text
	
	update_save_button_availability()

func _on_export_line_edit_text_changed(_new_text):
	update_file_list()
	check_reset_path_availability()
	
func _on_use_path_as_default_button_pressed():
	PreferencesManager.set_new_save_file_path(exportLineEdit.text)
	check_reset_path_availability()

### Helpers

func check_reset_path_availability():
	usePathAsDefaultButton.disabled = exportLineEdit.text == PreferencesManager.SAVE_DIR || exportLineEdit.text == ""
	resetPathButton.disabled = exportLineEdit.text == PreferencesManager.default_save_path

func save():
	SaveFileManager.setup_current_project_name(projectNameLineEdit.text)
	SaveFileManager.save(export_data)
	queue_free()

func update_file_list():
	saved_files_list.clear()
	file_list = SaveFileManager.list_files_in_directory(exportLineEdit.text)
	
	for file_name in file_list:
		saved_files_list.add_item(file_name)

func update_save_button_availability():
	saveButton.disabled = projectNameLineEdit.text == ""

func _on_delete_mode_button_pressed():
	selection_mode_toggle(false)

func _on_selection_mode_button_pressed():
	selection_mode_toggle(true)

func selection_mode_toggle(is_selection_mode_active):
	pathSelectionModeToggleButton.disabled = is_selection_mode_active
	fileDeletionModeToggleButton.disabled = !is_selection_mode_active

func _on_reset_path_button_pressed():
	exportLineEdit.text = PreferencesManager.default_save_path
	check_reset_path_availability()
	update_file_list()


func _cancel_button_pressed():
	queue_free()
