extends SimpleGraphNode

onready var textEdit = $MarginContainer/VBoxContainer/TextEdit
onready var commandsBlock = $MarginContainer/VBoxContainer/CommandsBlock

var type = "dialog"
var node_id = 0
var next_id = null

func set_next_id(id):
	next_id = id

func set_id(id):
	node_id = id

func get_data():
	var data = {
			"type":type,
			"text":textEdit.text,
			"next":next_id,
			"commands":commandsBlock.get_commands_array(),
			"graph_data": get_node_metadata()
		}
		
	return data

func set_graph_data(graph_data):
	textEdit.text = graph_data["text"]
	set_graph_node_property_data(graph_data["graph_data"])
	commandsBlock.load_data(graph_data["commands"])
