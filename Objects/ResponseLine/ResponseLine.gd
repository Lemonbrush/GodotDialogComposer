extends MarginContainer

signal option_line_deleted

onready var conditionBlock = $HBoxContainer/VBoxContainer/ConditionBlock
onready var textBox = $HBoxContainer/VBoxContainer/AdaptiveTextBox

var type = "ResponseLine"
var next_id = null

func get_data():
	return {
		"text":textBox.text,
		"next":next_id,
		"condition":get_condition_data()
	}

func get_condition_data():
	return conditionBlock.get_data()

func set_next_id(next):
	next_id = next

func get_type():
	return type

func _on_delete_button_pressed():
	emit_signal("option_line_deleted")
	queue_free()
