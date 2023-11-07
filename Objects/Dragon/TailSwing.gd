extends Node

@onready var state_name = self.name
@onready var dragon : Dragon = get_parent().get_parent()

func get_probability() -> float:
	if dragon.player_distance <= 4.2 and dragon.player_face_angle > 120.0:
		return .6
	else:
		return 0.0

func effect_start():
	await get_tree().create_timer(1.2).timeout
	dragon.tail_area.activate()
	await get_tree().create_timer(2.2).timeout
	if is_active():
		next_state = "Idle"

func effect_process(delta):
	pass

var next_state = ""
func get_next_state():
	var value = next_state
	next_state = ""
	return next_state

func is_active():
	return dragon.current_state_object == self
