class_name DragonState extends Node

@onready var state_name : String = self.name
@onready var dragon : Dragon = get_parent().get_parent()

func get_probability() -> float:
	return 0.0

func effect_start(index : int):
	pass

func effect_process(delta : float):
	pass

var next_state : String = ""
func get_next_state() -> String:
	var value := next_state
	next_state = ""
	return value

var counter : int = 0
var current_index : int
func set_active() -> int:
	counter += 1
	current_index = counter
	return current_index

func is_active(index : int = -1):
	if index == -1:
		return dragon.current_state_object == self
	else:
		return dragon.current_state_object == self and index == current_index

