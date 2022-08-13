extends HBoxContainer

signal command_line_delete_button_pressed

onready var line_edit = $LineEdit

func _on_delete_button_pressed():
	emit_signal("command_line_delete_button_pressed")
	queue_free()

func get_data():
	return line_edit.text
