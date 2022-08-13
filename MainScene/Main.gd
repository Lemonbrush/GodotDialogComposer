extends Control

var phrase_graph_node = load("res://Nodes/Phrase node/PhraseNode.tscn")
var condition_graph_node = load("res://Nodes/Condition node/ConditionNode.tscn")
#var response_graph_node = load("res://SimpleGraphNode.tscn")
var initial_graph_node = load("res://Nodes/Initial/InitialDialogNode.tscn")

var response_graph_node = load("res://Nodes/Response node/ResponseNode.tscn")

var initial_position = Vector2(40, 40)
var node_index = 0

onready var graphEdit = $GraphEdit
onready var beginNodeButton = $HBoxContainer/AddBeginNodeButton
onready var popupMenu = $PopupMenu

var initialNode = null

func _ready():
	popupMenu.add_item("Phrase", 0)
	popupMenu.add_item("Condition", 1)
	popupMenu.add_item("Response", 2)
	popupMenu.connect("id_pressed", self, "_on_popup_id_pressed")

### Actions

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	graphEdit.connect_node(from, from_slot, to, to_slot)

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	graphEdit.disconnect_node(from, from_slot, to, to_slot)

func _on_save_button_pressed():
	set_ids_for_nodes()
	connect_nodes()
	
	var export_data = {}
	
	var connection_list = graphEdit.get_connection_list()
	for i in range(0,connection_list.size()):
		var node_to = graphEdit.get_node(connection_list[i].to)
		export_data[node_to.node_id] = node_to.get_data()

	JSONExporter.save_as_json(export_data)

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

func connect_dialog_node(from, to): 
	from.next_id = to.node_id

func connect_condition_node(from, to, from_port): 
	if from_port == 0:
		from.condition_satisfied_next_id = to.node_id
	else:
		from.default_next_id = to.node_id

### Setting ids for nodes

func set_ids_for_nodes():
	var connection_list = graphEdit.get_connection_list()
	
	var node_counter = 0
	
	for i in range(0,connection_list.size()):
		var node = graphEdit.get_node(connection_list[i].to)
		node.set_id(node_counter)
		node_counter += 1
		#print(node.get_data())

func _on_add_begin_node_button_pressed():
	var node = initial_graph_node.instance()
	node.offset += initial_position + (node_index * Vector2(20, 20))
	node.title = node.title
	graphEdit.add_child(node)
	node_index += 1
	initialNode = node
	initialNode.connect("initial_node_deleted", self, "_on_initial_node_deleted")
	beginNodeButton.disabled = true

func _on_initial_node_deleted():
	initialNode = null
	beginNodeButton.disabled = false

func _on_GraphEdit_connection_to_empty(from, from_slot, _release_position):
	var mouse_position = get_global_mouse_position()
	popupMenu.from_node = from
	popupMenu.from_slot = from_slot
		
	popupMenu.popup(Rect2(mouse_position.x - 40, mouse_position.y - 20, popupMenu.rect_size.x, popupMenu.rect_size.y))
	
### Helpers
	
func _on_popup_id_pressed(id):
	match id:
		0: create_node(popupMenu.get_global_mouse_position(), phrase_graph_node)
		1: create_node(popupMenu.get_global_mouse_position(), condition_graph_node)
		2: create_node(popupMenu.get_global_mouse_position(), response_graph_node)
		_: return null
	
func create_node(position, node_link):
	var node = node_link.instance()
	node.offset += initial_position + (node_index * Vector2(20, 20))
	node.title = node.title
	graphEdit.add_child(node)
	node_index += 1
	
	if position:
		node.offset = get_global_mouse_position()
		graphEdit.connect_node(popupMenu.from_node, popupMenu.from_slot, node.get_name(), 0)
