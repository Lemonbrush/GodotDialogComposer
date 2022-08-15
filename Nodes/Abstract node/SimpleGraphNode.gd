extends GraphNode
class_name SimpleGraphNode

signal initial_node_deleted

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
