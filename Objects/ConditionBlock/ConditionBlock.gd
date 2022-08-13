extends MarginContainer

onready var add_line_button = $AddLine
onready var condition_line = $ConditionLine
onready var sign_option_button = $ConditionLine/SignOptionButton
onready var condition_name_line = $ConditionLine/VBoxContainer/ConditionNameLine
onready var value_line = $ConditionLine/VBoxContainer3/ValueLine

var signs = {
	0:"=",
	1:">",
	2:"<",
	3:">=",
	4:"<="
}

func _ready():
	sign_option_button.add_item(signs[0], 0)
	sign_option_button.add_item(signs[1], 1)
	sign_option_button.add_item(signs[2], 2)
	sign_option_button.add_item(signs[3], 3)
	sign_option_button.add_item(signs[4], 4)
	
func get_data():
	return {
		"name":condition_name_line.text,
		"sign":signs[sign_option_button.get_selected_id()],
		"value":value_line.text
	}

func _on_delete_button_pressed():
	add_line_button.visible = true
	condition_line.visible = false
	
	sign_option_button.select(0)
	condition_name_line.text =""
	value_line.text = ""
	

func _on_add_line_pressed():
	add_line_button.visible = false
	condition_line.visible = true
