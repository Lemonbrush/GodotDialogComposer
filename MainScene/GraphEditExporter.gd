extends Node

export (NodePath) var main_scene_path
export (NodePath) var graphEdit_path

func get_export_json_data():
	var graphEdit = get_node(graphEdit_path)
	
	if graphEdit == null:
		return
	
	set_ids_for_nodes()
	connect_nodes()
	
	var export_data = {}
	
	var connection_list = graphEdit.get_connection_list()
	export_data["connections"] = connection_list
	
	var graphNodes = graphEdit.get_children()
	for i in range(0, graphNodes.size()):
		var node = graphNodes[i]
		if node.has_method("get_data"):
			export_data[node.node_id] = node.get_data()

	return export_data

func get_node_data_key(node):
	var initial_node = get_node(main_scene_path).get_initial_node()
	if initial_node != null && initial_node == node:
		return "Initial"

func set_ids_for_nodes():
	var graphEdit = get_node(graphEdit_path)
	
	if graphEdit == null:
		return
	
	var connection_list = graphEdit.get_connection_list()
	
	if connection_list.size() == 0:
		return
	
	var node_counter = 1
	
	var first_node = graphEdit.get_node(connection_list[0].from)
	if first_node != null:
		first_node.set_id(0)
	
	for i in range(0,connection_list.size()):
		var node = graphEdit.get_node(connection_list[i].to)
		var initial_node_id = get_node_data_key(node)
		if initial_node_id:
			node.set_id(initial_node_id)
		else:
			node.set_id(node_counter)
			node_counter += 1

func connect_nodes():
	var graphEdit = get_node(graphEdit_path)
	
	if graphEdit == null:
		return
		
	var connection_list = graphEdit.get_connection_list()
	for i in range(0,connection_list.size()):
		var connection = connection_list[i]
		var node_from = graphEdit.get_node(connection.from)
		var node_to = graphEdit.get_node(connection.to)

		connect_two_nodes(node_from, node_to, connection.from_port)

func connect_two_nodes(from, to, from_port):
	match from.type:
		"dialog":connect_dialog_node(from, to)
		"condition": connect_condition_node(from, to, from_port)
		"response": connect_response_node(from, to, from_port)

func connect_dialog_node(from, to): 
	from.next_id = to.node_id

func connect_condition_node(from, to, from_port): 
	if from_port == 0:
		from.condition_satisfied_next_id = to.node_id
	else:
		from.default_next_id = to.node_id

func connect_response_node(from, to, from_port):
	from.set_next_id_for_choice_number(from_port, to.node_id)
