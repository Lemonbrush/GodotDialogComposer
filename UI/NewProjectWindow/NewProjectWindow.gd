extends CanvasLayer

signal project_created

onready var create_button = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/ButtonsContainer/CreateButton
onready var line_edit = $MainMarginContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/LineContainer/LineEdit

### Actions

func _on_create_button_pressed():
	SaveFileManager.save_file_resource.project_name = line_edit.text
	emit_signal("project_created")
	queue_free()  

func _on_cancel_button_pressed():
	queue_free() 

func _on_line_edit_text_changed(new_text):
	create_button.disabled = line_edit.text == ""

### Helpers
