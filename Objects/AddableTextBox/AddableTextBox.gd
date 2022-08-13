extends VBoxContainer

onready var add_text_box_button = $AddTextButton
onready var text_box_block = $TextBoxBlock
onready var adaptive_text_box = $TextBoxBlock/HBoxContainer/AdaptiveTextBox

var text = ""

func _on_add_text_button_pressed():
	add_text_box_button.visible = false
	text_box_block.visible = true

func _on_delete_button_pressed():
	add_text_box_button.visible = true
	text_box_block.visible = false
	text = ""
	adaptive_text_box.text = ""
	adaptive_text_box.rect_min_size.y = 30
