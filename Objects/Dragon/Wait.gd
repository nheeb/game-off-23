extends Node

@onready var state_name = self.name
@onready var dragon : Dragon = get_parent().get_parent()

var duration := 0.0
var timer := 0.0

func get_probability() -> float:
	return 0.1

func effect_start():
	duration = [0.8, 2.0, 3.5].pick_random()
	timer = duration

func effect_process(delta):
	timer -= delta
	if timer <= 0.0:
		next_state = "Idle"

var next_state := ""
func get_next_state():
	var value := next_state
	next_state = ""
	return next_state

func is_active() -> bool:
	return dragon.current_state_object == self
