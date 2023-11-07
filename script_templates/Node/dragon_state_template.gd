extends Node

@onready var state_name := self.name
@onready var dragon : Dragon = get_parent().get_parent()

func get_probability() -> float:
	return 0.0

func effect_start():
	pass

func effect_process(delta: float):
	pass

var next_state := ""
func get_next_state():
	var value := next_state
	next_state = ""
	return next_state

func is_active() -> bool:
	return dragon.current_state_object == self
