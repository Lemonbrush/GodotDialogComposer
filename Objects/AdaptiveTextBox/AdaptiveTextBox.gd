extends TextEdit

export (int) var text_edit_line_height = 20

func _on_TextEdit_text_changed():
	rect_min_size.y = get_line_count() * text_edit_line_height
