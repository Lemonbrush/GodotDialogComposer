extends SimpleGraphNode

onready var textBox = $TextBoxContainer/AddableTextBox
onready var commands_block = $MarginContainer/CommandsBlock

var response_line = load("res://Objects/ResponseLine/ResponseLine.tscn")

var type = "response"
var node_id = 0

func get_data():
	var data = {
			"type":type,
			"text":textBox.get_data(),
			"responses": get_responses(),
			"commands": commands_block.get_commands_array(),
			"graph_data": get_node_metadata()
		}
	return data

func set_graph_data(graph_data):
	textBox.set_data(graph_data["text"])
	set_graph_node_property_data(graph_data["graph_data"])
	commands_block.load_data(graph_data["commands"])
	load_responses_data(graph_data["responses"])

func load_responses_data(responses_data):
	for response in responses_data:
		add_option(response)

func set_id(id):
	node_id = id
	
func set_next_id_for_choice_number(number, next_id):
	var response_line_node = get_children()[number + 3]
	response_line_node.set_next_id(next_id)

func get_responses():
	var responses_array = []
	for child in get_children():
		if child.has_method("get_type") && child.get_type() == "ResponseLine":
			responses_array.append(child.get_data())
	
	return responses_array
	
func _on_option_line_deleted():
	yield(get_tree(), "idle_frame")
	rect_size = Vector2(rect_size.x, 0)

func _on_add_option_pressed():
	add_option()

func add_option(data = null):
	var responseline_instance = response_line.instance()
	add_child(responseline_instance)
	responseline_instance.connect("option_line_deleted", self, "_on_option_line_deleted")
	
	set_slot(get_children().size() - 1,false,0,Color(1,1,1,1),true,0,Color(1,1,1,1))
	
	if data != null:
		responseline_instance.set_data(data)
