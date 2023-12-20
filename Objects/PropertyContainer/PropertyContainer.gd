extends VBoxContainer

signal did_color_property_changed(color)

onready var add_property_popup_menu = $AddPropertyButton
onready var add_condition_popup_menu = $AddConditionPopupMenu

onready var conditions_property = $Properties/ConditionsVBoxContainer
onready var color_property = $Properties/ColorPickerButton

func _ready():
	add_property_popup_menu.connect("did_chose_add_color_property", self, "add_color_block")
	add_property_popup_menu.connect("did_chose_add_condition_property", self, "add_conditions_block")
	
	add_condition_popup_menu.connect("did_press_add_numeric_condition", self, "add_numeric_condition")
	add_condition_popup_menu.connect("did_press_add_boolean_condition", self, "add_boolean_condition")
	add_condition_popup_menu.connect("did_press_add_string_condition", self, "add_string_condition")
	
	color_property.connect("color_changed", self, "did_color_property_changed")

func load_conditions_data(data):
	conditions_property.load_data(data)

func load_color_data(color):
	color_property.load_data(color)

func get_conditions_data():
	return conditions_property.get_data()

func get_color_data():
	return color_property.get_data()

func did_color_property_changed(color):
	emit_signal("did_color_property_changed", color)

func add_color_block():
	color_property.visible = !color_property.visible
	if !color_property.visible:
		color_property.reset()

func add_conditions_block():
	var mouse_position = get_global_mouse_position()
	var rect = Rect2(
		mouse_position.x - 40, 
		mouse_position.y - 20, 
		add_property_popup_menu.rect_size.x, 
		add_property_popup_menu.rect_size.y
		)
	add_condition_popup_menu.popup(rect)

func add_numeric_condition():
	conditions_property.add_numeric_condition()

func add_boolean_condition():
	conditions_property.add_boolean_condition()

func add_string_condition():
	conditions_property.add_string_condition()
