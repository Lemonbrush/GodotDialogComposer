extends MarginContainer

onready var condition_line = $ConditionLine
onready var sign_option_button = $ConditionLine/SignOptionButton
onready var condition_name_line = $ConditionLine/ConditionNameField/ConditionNameLine
onready var value_field = $ConditionLine/ValueContainer/ValueLine
onready var value_field_block = $ConditionLine/ValueContainer
onready var boolian_button = $ConditionLine/BoolianButton

var ConditionValueType = preload("res://Singletons/ConditionValueType.gd")

var condition_value_type

var signs = ["=", ">", "<", ">=", "<="]

func _ready():
	for i in range(0, signs.size()):
		sign_option_button.add_item(signs[i], i)
	
func get_data():
	if condition_name_line.text == null || condition_name_line.text == "":
		return null
		
	var condition_sign
	var condition_value
	
	if condition_value_type == int(ConditionValueType.BOOLIAN):
		condition_sign = "="
		condition_value = get_boolian_button_value()
	elif condition_value_type == int(ConditionValueType.STRING):
		condition_sign = "="
		condition_value = value_field.text
	elif condition_value_type == int(ConditionValueType.NUMERIC):
		condition_sign = signs[sign_option_button.get_selected_id()]
		condition_value = int(value_field.text)
	
	var data = { 
		"condition": condition_name_line.text,
		"sign": condition_sign,
		"value": condition_value,
		"condition_value_type": condition_value_type
		}
		
	return  data

func set_data(condition_line_data):
	condition_value_type = condition_line_data["condition_value_type"]
	condition_name_line.text = condition_line_data["condition"]
	sign_option_button.select(get_sign_id(condition_line_data["sign"]))
	value_field.text = str(condition_line_data["value"])
	
	if condition_value_type == ConditionValueType.BOOLIAN:
		boolian_button.text = str(condition_line_data["value"]).to_lower()
	
	set_condition_value_type(condition_value_type)

func _on_delete_button_pressed():
	queue_free()

func get_sign_id(sign_str):
	for i in range(0, signs.size()):
		if signs[i] == sign_str:
			return i
	
	return 0

func setup_numeric_appearance():
	sign_option_button.visible = true
	boolian_button.visible = false
	value_field.visible = true

func setup_boolian_appearance():
	sign_option_button.visible = false
	boolian_button.visible = true
	value_field_block.visible = false

func setup_string_appearance():
	sign_option_button.visible = false
	boolian_button.visible = false
	value_field.visible = true

func set_condition_value_type(new_condition_value_type):
	condition_value_type = new_condition_value_type

	if condition_value_type == int(ConditionValueType.NUMERIC):
		setup_numeric_appearance()
	elif condition_value_type == int(ConditionValueType.BOOLIAN):
		setup_boolian_appearance()
	elif condition_value_type == int(ConditionValueType.STRING): 
		setup_string_appearance()

func get_boolian_button_value():
	match boolian_button.text:
		"true": return true
		"false": return false

func _on_boolian_button_pressed():
	boolian_button.text = str(!get_boolian_button_value()).to_lower()
