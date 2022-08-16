extends VBoxContainer

onready var conditions_container = $ConditionsContainer

var condition_line = load("res://Objects/ConditionLine/ConditionLine.tscn")

func _on_add_condition_button_pressed():
	create_condition_line()

func get_data():
	var condition_lines = []
	for c_line in conditions_container.get_children():
		if c_line.has_method("get_data"):
			var data = c_line.get_data()
			if data != null:
				condition_lines.append(data)
	
	if condition_lines.size() > 0:
		return condition_lines

func load_data(data):
	if data == null:
		return
	
	for condition_line in data:
		create_condition_line(condition_line)

func create_condition_line(condition_text = null):
	var condition_line_instance = condition_line.instance()
	conditions_container.add_child(condition_line_instance)
	
	if condition_text != null:
		condition_line_instance.set_data(condition_text)
