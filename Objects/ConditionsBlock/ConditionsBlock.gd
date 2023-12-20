extends VBoxContainer

onready var conditions_container = $ConditionsContainer
onready var addConditionButton = $AddConditionButton

var ConditionValueType = preload("res://Singletons/ConditionValueType.gd")
var condition_line = load("res://Objects/ConditionLine/ConditionLine.tscn")

func _ready():
	addConditionButton.get_popup().add_item("Numeric", 0)
	addConditionButton.get_popup().add_item("Boolian", 1)
	addConditionButton.get_popup().add_item("String",2)
	
	addConditionButton.get_popup().connect("id_pressed", self, "_on_add_conditionButton_menu_index_pressed")

func get_data():
	var condition_lines = []
	for c_line in conditions_container.get_children():
		if c_line.has_method("get_data"):
			var data = c_line.get_data()
			if data != null:
				condition_lines.append(data)
	
	if condition_lines.size() > 0:
		return condition_lines

func reset():
	for line in conditions_container.get_children():
		line.queue_free()

func load_data(data):
	if data == null:
		return
	
	for condition_line_data in data:
		create_condition_line(condition_line_data)

func create_empty_condition_line(condition_line_type):
	var condition_line_instance = condition_line.instance()
	conditions_container.add_child(condition_line_instance)
	
	condition_line_instance.set_condition_value_type(condition_line_type)

func create_condition_line(condition_line_data):
	var condition_line_instance = condition_line.instance()
	conditions_container.add_child(condition_line_instance)
	
	condition_line_instance.set_data(condition_line_data)

func _on_add_conditionButton_menu_index_pressed(index):
	match index:
		0: create_empty_condition_line(ConditionValueType.NUMERIC)
		1: create_empty_condition_line(ConditionValueType.BOOLIAN)
		2: create_empty_condition_line(ConditionValueType.STRING)
		_: create_empty_condition_line(ConditionValueType.NUMERIC)


func _on_add_condition_button_pressed():
	addConditionButton.get_popup()
