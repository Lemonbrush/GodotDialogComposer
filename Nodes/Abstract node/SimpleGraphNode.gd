extends GraphNode
class_name SimpleGraphNode

signal initial_node_deleted

var is_initial_node = false

func _on_Control_close_request():
	if is_initial_node:
		emit_signal("initial_node_deleted")
	queue_free()

func _on_Control_resize_request(new_minsize):
	rect_size = Vector2(new_minsize.x,0)

func get_node_metadata():
	return {
		"x": rect_position.x,
		"y": rect_position.y,
		"width": rect_size.x,
		"height": rect_size.y,
		"node_name":name,
		"initial_node": is_initial_node
	}

func set_graph_node_property_data(graph_params_data):
	name = graph_params_data["node_name"]
	set_size(Vector2(float(graph_params_data["width"]), float(graph_params_data["height"])))
	set_offset(Vector2(float(graph_params_data["x"]), float(graph_params_data["y"])))
	set_initial_mode(graph_params_data["initial_node"])

func delete():
	name = "deleted"
	queue_free()

func set_initial_mode(is_mode_active):
	is_initial_node = is_mode_active
	if is_mode_active:
		modulate = Color(0.8,1,0.8,1)
	else:
		modulate = Color(1,1,1,1)
