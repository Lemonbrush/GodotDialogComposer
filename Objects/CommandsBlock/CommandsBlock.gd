extends VBoxContainer

onready var commands_container = $CommandsContainer

var command_line = load("res://Objects/CommandLine/CommandLine.tscn")

func get_commands_array():
	var commands_array = []
	
	for local_command_line in commands_container.get_children():
		if local_command_line.has_method("get_data"):
			commands_array.append(local_command_line.get_data())
			
func _on_add_command_button_pressed():
	var command_line_instance = command_line.instance()
	var _connection = command_line_instance.connect("command_line_delete_button_pressed", self, "_on_line_delete_button_pressed")
	commands_container.add_child(command_line_instance)
