extends SimpleGraphNode

onready var textBox = $TextBoxContainer/TextBoxVBox/AddableTextBox
onready var commands_block = $MarginContainer/CommandsBlock

var response_line = load("res://Objects/ResponseLine/ResponseLine.tscn")

var type = "response"
var node_id = 0

func get_data():
	var text
	if textBox.text == "":
		text = null
	else:
		text = textBox.text
		
	var data = {
			"type":type,
			"text":text,
			"responses": get_responses(),
			"commands": commands_block.get_commands_array()
		}
	return data

func set_id(id):
	node_id = id
	
func set_next_id_for_choice_number(number, next_id):
	var response_line_node = get_children()[number + 3]
	print(response_line_node)
	response_line_node.set_next_id(next_id)

func get_responses():
	var responses_array = []
	for child in get_children():
		if child.has_method("get_type") && child.get_type() == "ResponseLine":
			responses_array.append(child.get_data())
	
	print(responses_array)
	return responses_array
	
func _on_option_line_deleted():
	yield(get_tree(), "idle_frame")
	rect_size = Vector2(rect_size.x, 0)

func _on_add_command_pressed():
	var command_line_instance = response_line.instance()
	var _connection = command_line_instance.connect("command_line_delete_button_pressed", self, "_on_line_delete_button_pressed")
	add_child(command_line_instance)
	command_line_instance.connect("option_line_deleted", self, "_on_option_line_deleted")
	
	var children = get_children()
	set_slot(children.size() - 1,false,0,Color(1,1,1,1),true,0,Color(1,1,1,1))
