extends VBoxContainer

enum CONDITION {
	NUMERIC = 0,
	BOOLEAN = 1,
	STRING = 2
}

var condition_line = load("res://Objects/ConditionLine/ConditionLine.tscn")

func get_data():
	var condition_lines = []
	for condition_line_object in get_children():
		if !condition_line_object.has_method("get_data"):
			continue
		var condition_line_data = condition_line_object.get_data()
		if condition_line_data != null:
			condition_lines.append(condition_line_data)
	if condition_lines.size() > 0:
		return condition_lines

func reset():
	for condition_line_object in get_children():
		condition_line_object.queue_free()

func load_data(data):
	if data == null:
		return
	for condition_line_data in data:
		_create_condition_line(condition_line_data)

func add_numeric_condition():
	_create_empty_condition_line(CONDITION.NUMERIC)

func add_boolean_condition():
	_create_empty_condition_line(CONDITION.BOOLEAN)

func add_string_condition():
	_create_empty_condition_line(CONDITION.STRING)

func _create_empty_condition_line(condition_line_type):
	var condition_line_instance = condition_line.instance()
	add_child(condition_line_instance)
	condition_line_instance.set_condition_value_type(condition_line_type)

func _create_condition_line(condition_line_data):
	var condition_line_instance = condition_line.instance()
	add_child(condition_line_instance)
	condition_line_instance.set_data(condition_line_data)
