extends SimpleGraphNode

onready var conditionNameLine = $VBoxContainer/HBoxContainer2/VBoxContainer/ConditionNameLine
onready var signLine = $VBoxContainer/HBoxContainer2/VBoxContainer2/SignLine
onready var valueLine = $VBoxContainer/HBoxContainer2/VBoxContainer3/ValueLine
onready var conditionBlock = $VBoxContainer/ConditionBlock

var type = "condition"
var node_id = 0
var default_next_id = null
var condition_satisfied_next_id = null

func set_next_default_id(id):
	default_next_id = id

func set_next_condition_satisfied_id(id):
	condition_satisfied_next_id = id

func set_id(id):
	node_id = id

func get_data():
	var condition = conditionBlock.get_data()
	
	var data = {
			"type":type,
			"condition_name":condition["name"],
			"condition_value":condition["value"],
			"condition_sign":condition["sign"],
			"condition_satisfied":condition_satisfied_next_id,
			"default":default_next_id
		}
	return data
