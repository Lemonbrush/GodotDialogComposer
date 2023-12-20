extends PopupMenu

signal did_press_add_numeric_condition()
signal did_press_add_boolean_condition()
signal did_press_add_string_condition()

enum CONDITION {
	NUMERIC = 0,
	BOOLEAN = 1,
	STRING = 2
}

func _ready():
	add_item("Numeric", CONDITION.NUMERIC)
	add_item("Boolean", CONDITION.BOOLEAN)
	add_item("String", CONDITION.STRING)
	connect("id_pressed", self, "did_press_option")

func did_press_option(option_id):
	match option_id:
		CONDITION.NUMERIC: emit_signal("did_press_add_numeric_condition")
		CONDITION.BOOLEAN: emit_signal("did_press_add_boolean_condition")
		CONDITION.STRING: emit_signal("did_press_add_string_condition")
