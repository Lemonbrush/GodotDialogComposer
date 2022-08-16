extends VBoxContainer

onready var commands_container = $CommandsContainer

var command_line = load("res://Objects/CommandLine/CommandLine.tscn")

func get_commands_array():
	var commands_array = []
	
	for local_command_line in commands_container.get_children():
		if local_command_line.has_method("get_data"):
			var data = local_command_line.get_data()
			if data != null:
				commands_array.append(data)
	
	if commands_array.size() > 0:
		return commands_array
			
func _on_add_command_button_pressed():
	add_command_line()

func load_data(commands):
	if commands == null:
		return
	
	for command in commands:
		add_command_line(command)

func add_command_line(text = ""):
	var command_line_instance = command_line.instance()
	var _connection = command_line_instance.connect("command_line_delete_button_pressed", self, "_on_line_delete_button_pressed")
	commands_container.add_child(command_line_instance)
	command_line_instance.set_data(text)
