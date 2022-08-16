extends Control

var phrase_graph_node = load("res://Nodes/Phrase node/PhraseNode.tscn")
var condition_graph_node = load("res://Nodes/Condition node/ConditionNode.tscn")
var response_graph_node = load("res://Nodes/Response node/ResponseNode.tscn")

var export_window = load("res://UI/ExportWindow/ExportWindow.tscn")
var load_window = load("res://UI/LoadWindow/LoadWindow.tscn")

var initial_position = Vector2(40, 40)

onready var graphEdit = $GraphEdit
onready var popupMenu = $PopupMenu
onready var filePopupMenu = $FilePopupMenu
onready var fileButton = $OptionsPanel/FileButton
onready var optionsPanel = $OptionsPanel
onready var graphEditExporter = $GraphEditExporter

func _ready():
	filePopupMenu.add_item("Load", 0)
	filePopupMenu.add_item("Save", 1)
	filePopupMenu.add_item("Clear", 2)
	filePopupMenu.connect("id_pressed", self, "_on_file_popup_id_pressed")
	
	popupMenu.add_item("Phrase", 0)
	popupMenu.add_item("Condition", 1)
	popupMenu.add_item("Response", 2)
	popupMenu.connect("id_pressed", self, "_on_popup_id_pressed")

func _input(event):
	if event.is_pressed() and event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		var mouse_position = get_global_mouse_position()
		popupMenu.reset_data()
		popupMenu.popup(Rect2(mouse_position.x - 40, mouse_position.y - 20, popupMenu.rect_size.x, popupMenu.rect_size.y))
	elif Input.is_action_just_pressed("save"):
		SaveFileManager.shortcut_save(graphEditExporter.get_export_json_data())

### Actions

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	graphEdit.connect_node(from, from_slot, to, to_slot)

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	graphEdit.disconnect_node(from, from_slot, to, to_slot)

func _on_file_button_pressed():
	var is_project_empty = SaveFileManager.save_file_resource.project_name == ""
	filePopupMenu.popup(Rect2(optionsPanel.rect_position.x, optionsPanel.rect_position.y, filePopupMenu.rect_size.x, filePopupMenu.rect_size.y))

func _on_file_popup_id_pressed(id):	
	match id:
		0: show_window_with_scene(load_window)
		1: show_export_window()
		2: clear_graph_edit()

func _on_popup_id_pressed(id):
	match id:
		0: create_node(popupMenu.get_global_mouse_position(), phrase_graph_node)
		1: create_node(popupMenu.get_global_mouse_position(), condition_graph_node)
		2: create_node(popupMenu.get_global_mouse_position(), response_graph_node)
		_: return null

func _on_GraphEdit_connection_to_empty(from, from_slot, _release_position):
	var mouse_position = get_global_mouse_position()
	popupMenu.from_node = from
	popupMenu.from_slot = from_slot
		
	popupMenu.popup(Rect2(mouse_position.x - 40, mouse_position.y - 20, popupMenu.rect_size.x, popupMenu.rect_size.y))

func show_export_window():
	var export_window_instance = export_window.instance()
	export_window_instance.export_data = graphEditExporter.get_export_json_data()
	graphEdit.add_child(export_window_instance)
	
### Helpers

func clear_graph_edit():
	for i in graphEdit.get_children():
		if i.has_method("delete"):
			i.delete()

func show_window_with_scene(scene):
	var scene_instance = scene.instance()
	graphEdit.add_child(scene_instance)
	
func create_node(position, node_link):
	var node = node_link.instance()
	graphEdit.add_child(node)
	node.name = str(hash(node))
	
	if position:
		node.offset = get_global_mouse_position()
		if popupMenu.from_node != null && popupMenu.from_slot != null:
			graphEdit.connect_node(popupMenu.from_node, popupMenu.from_slot, node.get_name(), 0)
