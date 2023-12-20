extends MenuButton

signal did_chose_add_color_property()
signal did_chose_add_condition_property()

enum PROPERTY {
	COLOR = 0,
	CONDITIONS = 1
}

func _ready():
	get_popup().add_item("Color", PROPERTY.COLOR)
	get_popup().add_item("Conditions", PROPERTY.CONDITIONS)
	get_popup().connect("id_pressed", self, "did_press_option")

func did_press_option(option_id):
	match option_id:
		PROPERTY.COLOR: emit_signal("did_chose_add_color_property")
		PROPERTY.CONDITIONS: emit_signal("did_chose_add_condition_property")
