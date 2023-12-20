extends MarginContainer

signal option_line_deleted

onready var property_block = $MarginContainer/HBoxContainer/VBoxContainer/PropertyContainer
onready var text_input_block = $MarginContainer/HBoxContainer/VBoxContainer/AdaptiveTextBox

var type = "ResponseLine"
var next_id = null

func get_data():
	return {
		"text": text_input_block.text,
		"next":str(next_id),
		"conditions": get_conditions_data(),
		"color": get_color_data()
	}

func set_data(data):
	text_input_block.text = data["text"]
	property_block.load_conditions_data(data["conditions"])
	if data.has("color"):
		property_block.load_color_data(data["color"])

func get_conditions_data():
	return property_block.get_conditions_data()

func get_color_data():
	var col = property_block.get_color_data()
	return col

func set_next_id(next):
	next_id = next

func get_type():
	return type

func _on_delete_button_pressed():
	emit_signal("option_line_deleted")
	queue_free()

func _on_PropertyContainer_did_color_property_changed(color):
	text_input_block.set_text_color(color)
