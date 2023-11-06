extends Node

@onready var state_name := self.name

func get_probability() -> float:
	return 0.0

func effect_start():
	pass

func effect_process(delta: float):
	pass

func get_next_state() -> String:
	return ""
