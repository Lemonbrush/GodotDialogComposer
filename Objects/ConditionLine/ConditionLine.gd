extends MarginContainer

onready var condition_line = $ConditionLine
onready var sign_option_button = $ConditionLine/SignOptionButton
onready var condition_name_line = $ConditionLine/VBoxContainer/ConditionNameLine
onready var value_line = $ConditionLine/VBoxContainer3/ValueLine

var signs = ["=", ">", "<", ">=", "<="]

func _ready():
	for i in range(0, signs.size()):
		sign_option_button.add_item(signs[i], i)
	
func get_data():
	if condition_name_line.text == null || condition_name_line.text == "":
		return null
	
	return condition_name_line.text + " " + signs[sign_option_button.get_selected_id()] + " " + value_line.text

func set_data(condition_text):
	var args = condition_text.split(" ")
	
	if args.size() != 3:
		return
		
	condition_name_line.text = args[0]
	sign_option_button.select(get_sign_id(args[1]))
	value_line.text = args[2]

func _on_delete_button_pressed():
	queue_free()

func get_sign_id(sign_str):
	for i in range(0, signs.size()):
		if signs[i] == sign_str:
			return i
	
	return 0
