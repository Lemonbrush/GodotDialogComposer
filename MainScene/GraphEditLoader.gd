extends Node

export (NodePath) var main_scene_path
export (NodePath) var graphEdit_path

var phrase_graph_node = load("res://Nodes/Phrase node/PhraseNode.tscn")
var condition_graph_node = load("res://Nodes/Condition node/ConditionNode.tscn")
var response_graph_node = load("res://Nodes/Response node/ResponseNode.tscn")

func _ready():
	SaveFileManager.connect("project_loaded", self, "_on_project_loaded")

func _on_project_loaded(project_data):
	var connections = project_data["connections"]
	var main_scene = get_node(main_scene_path)
	main_scene.clear_graph_edit()
	
	for i in project_data:
		if not (project_data[i] is String) && project_data[i].has("graph_data"):
			var node_data = project_data[i]
			match node_data["type"]:
				"response":load_node(response_graph_node, node_data)
				"dialog":load_node(phrase_graph_node, node_data)
				"condition":load_node(condition_graph_node, node_data)
	
	for connection in connections:
		get_node(graphEdit_path).connect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])

func load_node(node, data):
	var phrase_node = node.instance()
	get_node(graphEdit_path).add_child(phrase_node)
	phrase_node.set_graph_data(data)
	phrase_node.connect("initial_node_deleted", get_node(main_scene_path), "_on_initial_node_deleted")
