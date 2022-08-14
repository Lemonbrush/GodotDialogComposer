extends Control

var phrase_graph_node = load("res://Nodes/Phrase node/PhraseNode.tscn")
var condition_graph_node = load("res://Nodes/Condition node/ConditionNode.tscn")
var initial_graph_node = load("res://Nodes/Initial/InitialDialogNode.tscn")

var response_graph_node = load("res://Nodes/Response node/ResponseNode.tscn")

var new_project_window = load("res://UI/NewProjectWindow/NewProjectWindow.tscn")
var export_window = load("res://UI/ExportWindow/ExportWindow.tscn")

var initial_position = Vector2(40, 40)
var node_index = 0

onready var graphEdit = $GraphEdit
onready var popupMenu = $PopupMenu
onready var filePopupMenu = $FilePopupMenu
onready var fileButton = $FileButton

func _ready():
	filePopupMenu.add_item("New project", 0)
	filePopupMenu.add_item("Load", 1)
	filePopupMenu.add_item("Save", 2)
	filePopupMenu.add_item("Export", 3)
	filePopupMenu.connect("id_pressed", self, "_on_file_popup_id_pressed")
	
	popupMenu.add_item("Phrase", 0)
	popupMenu.add_item("Condition", 1)
	popupMenu.add_item("Response", 2)
	popupMenu.connect("id_pressed", self, "_on_popup_id_pressed")

### Actions

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	graphEdit.connect_node(from, from_slot, to, to_slot)

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	graphEdit.disconnect_node(from, from_slot, to, to_slot)

func get_export_json_data():
	set_ids_for_nodes()
	connect_nodes()
	
	var export_data = {}
	
	var connection_list = graphEdit.get_connection_list()
	for i in range(0,connection_list.size()):
		var node_to = graphEdit.get_node(connection_list[i].to)
		export_data[node_to.node_id] = node_to.get_data()

	return export_data

func _on_file_button_pressed():
	print(SaveFileManager.save_file_resource.project_name)
	
	var is_project_empty = SaveFileManager.save_file_resource.project_name == ""
	filePopupMenu.set_item_disabled(2, is_project_empty)
	filePopupMenu.set_item_disabled(3, is_project_empty)
		
	filePopupMenu.popup(Rect2(fileButton.rect_position.x, fileButton.rect_position.y, filePopupMenu.rect_size.x, filePopupMenu.rect_size.y))

func _on_file_popup_id_pressed(id):	
	match id:
		0: show_new_project_window()
		1: create_node(popupMenu.get_global_mouse_position(), phrase_graph_node)
		2: create_node(popupMenu.get_global_mouse_position(), condition_graph_node)
		3: show_export_window()

func show_new_project_window():
	var new_project_window_instance = new_project_window.instance()
	graphEdit.add_child(new_project_window_instance)
	new_project_window_instance.connect("project_created", self, "_on_new_project_created")

func _on_popup_id_pressed(id):
	match id:
		0: create_node(popupMenu.get_global_mouse_position(), phrase_graph_node)
		1: create_node(popupMenu.get_global_mouse_position(), condition_graph_node)
		2: create_node(popupMenu.get_global_mouse_position(), response_graph_node)
		_: return null

func _on_new_project_created():
	var node = initial_graph_node.instance()
	node.offset += initial_position + (node_index * Vector2(20, 20))
	node.title = node.title
	graphEdit.add_child(node)
	node_index += 1

func show_export_window():
	var export_window_instance = export_window.instance()
	export_window_instance.export_data = get_export_json_data()
	graphEdit.add_child(export_window_instance)

### Nodes connection

func connect_nodes():
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

### Setting ids for nodes

func set_ids_for_nodes():
	var connection_list = graphEdit.get_connection_list()
	
	var node_counter = 0
	
	for i in range(0,connection_list.size()):
		var node = graphEdit.get_node(connection_list[i].to)
		node.set_id(node_counter)
		node_counter += 1

func _on_GraphEdit_connection_to_empty(from, from_slot, _release_position):
	var mouse_position = get_global_mouse_position()
	popupMenu.from_node = from
	popupMenu.from_slot = from_slot
		
	popupMenu.popup(Rect2(mouse_position.x - 40, mouse_position.y - 20, popupMenu.rect_size.x, popupMenu.rect_size.y))
	
### Helpers
	
func create_node(position, node_link):
	var node = node_link.instance()
	node.offset += initial_position + (node_index * Vector2(20, 20))
	node.title = node.title
	graphEdit.add_child(node)
	node_index += 1
	
	if position:
		node.offset = get_global_mouse_position()
		graphEdit.connect_node(popupMenu.from_node, popupMenu.from_slot, node.get_name(), 0)
