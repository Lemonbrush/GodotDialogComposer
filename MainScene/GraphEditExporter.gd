extends Node

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
	
	var first_node = graphEdit.get_node(connection_list[0].from)
	export_data[first_node.node_id] = first_node.get_data()
	
	for i in range(0,connection_list.size()):
		var node_to = graphEdit.get_node(connection_list[i].to)
		export_data[node_to.node_id] = node_to.get_data()

	return export_data

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
