extends GraphNode
class_name SimpleGraphNode

func _on_Control_close_request():
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
	}

func set_graph_node_property_data(graph_params_data):
	set_size(Vector2(float(graph_params_data["width"]), float(graph_params_data["height"])))
	set_offset(Vector2(float(graph_params_data["x"]), float(graph_params_data["y"])))

func delete():
	queue_free()
