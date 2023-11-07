extends Node

@onready var state_name := self.name
@onready var dragon : Dragon = get_parent().get_parent()

func get_probability() -> float:
	return 0.0

func effect_start():
	dragon.reset_behaviour()
	dragon.analyse_battlefield()
	dragon.choose_action()

func effect_process(delta: float):
	pass

var next_state := ""
func get_next_state() -> String:
	return next_state
