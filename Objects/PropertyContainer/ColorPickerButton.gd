extends ColorPickerButton

const default_color = Color(1,1,1,1)

func _ready():
	color = default_color
	connect("color_changed", self, "color_changed")

func reset():
	color = default_color
	emit_signal("color_changed", color)

func get_data():
	var cl = get_pick_color().to_html()
	return cl

func load_data(hex_string):
	var new_color = Color(hex_string)
	color = new_color
	visible = new_color != default_color
	emit_signal("color_changed", color)
