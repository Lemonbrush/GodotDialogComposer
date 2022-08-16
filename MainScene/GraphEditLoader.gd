extends Node

export (NodePath) var main_scene_path
export (NodePath) var graphEdit_path

var phrase_graph_node = load("res://Nodes/Phrase node/PhraseNode.tscn")
var condition_graph_node = load("res://Nodes/Condition node/ConditionNode.tscn")
var response_graph_node = load("res://Nodes/Response node/ResponseNode.tscn")

func _ready():
	SaveFileManager.connect("project_loaded", self, "_on_project_loaded")

func _on_project_loaded(project_data):
	get_node(main_scene_path).clear_graph_edit()
	
	for i in project_data:
		if not (project_data[i] is String) && project_data[i].has("graph_data"):
			var node_data = project_data[i]
			print(node_data)
			match node_data["type"]:
				"response":return
				"dialog":load_node(phrase_graph_node, node_data)
				"condition":return

func load_node(node, data):
	var phrase_node = node.instance()
	
	get_node(graphEdit_path).add_child(phrase_node)
	phrase_node.set_graph_data(data)
