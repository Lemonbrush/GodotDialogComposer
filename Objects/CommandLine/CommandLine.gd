extends HBoxContainer

signal command_line_delete_button_pressed

onready var line_edit = $LineEdit

func _on_delete_button_pressed():
	emit_signal("command_line_delete_button_pressed")
	queue_free()

func get_data():
	if line_edit.text != "":
		return line_edit.text

func set_data(new_text):
	if new_text == null:
		return
	
	line_edit.text = new_text
