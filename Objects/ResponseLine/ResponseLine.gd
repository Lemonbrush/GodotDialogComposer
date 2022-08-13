extends MarginContainer

signal option_line_deleted

onready var conditionBlock = $HBoxContainer/VBoxContainer/ConditionBlock
onready var textBox = $HBoxContainer/VBoxContainer/AdaptiveTextBox

var type = "ResponseLine"

func get_data():
	return {
		"text":textBox.text,
		"next":null,
		"condition":get_condition_data()
	}

func get_condition_data():
	var condition_data = conditionBlock.get_data()
	return {
		"condition_name": condition_data["name"],
		"condition_sign": condition_data["sign"],
		"condition_value": condition_data["value"]
	}

func get_type():
	return type

func _on_delete_button_pressed():
	emit_signal("option_line_deleted")
	queue_free()
