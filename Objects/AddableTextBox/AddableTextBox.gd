extends VBoxContainer

onready var add_text_box_button = $AddTextButton
onready var text_box_block = $TextBoxBlock
onready var adaptive_text_box = $TextBoxBlock/HBoxContainer/AdaptiveTextBox

func _on_add_text_button_pressed():
	active(true)

func _on_delete_button_pressed():
	active(false)
	adaptive_text_box.text = ""
	adaptive_text_box.rect_min_size.y = 30

func get_data():
	if text_box_block.visible:
		return adaptive_text_box.text

func set_data(text):
	if text != null:
		active(true)
		adaptive_text_box.text = text

func active(is_active):
	add_text_box_button.visible = !is_active
	text_box_block.visible = is_active
