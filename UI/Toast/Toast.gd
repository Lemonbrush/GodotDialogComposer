extends Node2D

export (String) var labelText = "TEXT"

onready var iconSprite = $Icon
onready var label = $Panel/Label

func _ready():
	label.text = labelText
