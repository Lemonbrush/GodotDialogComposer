extends SimpleGraphNode

onready var conditionsBlock = $ConditioonMarginContainer/ConditionBlock

var type = "condition"
var node_id = 0
var default_next_id = null
var condition_satisfied_next_id = null

func set_next_default_id(id):
	default_next_id = id

func set_next_condition_satisfied_id(id):
	condition_satisfied_next_id = id

func set_id(id):
	node_id = id

func get_data():
	var data = {
			"type":type,
			"conditions":conditionsBlock.get_data(),
			"true":condition_satisfied_next_id,
			"false":default_next_id,
			"graph_data": get_node_metadata()
		}
	return data

func set_graph_data(graph_data):
	set_graph_node_property_data(graph_data["graph_data"])
	conditionsBlock.load_data(graph_data["conditions"])
