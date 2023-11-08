extends DragonState

func get_probability() -> float:
	return 0.2 if dragon.player_face_angle < 30.0 else 0.05

var last_y_pos: float
func effect_start(index):
	last_y_pos = dragon.model.global_position.y
	await get_tree().create_timer(3.0).timeout
	if is_active(index):
		next_state = "Idle"
		dragon.model.global_position.y = last_y_pos

func effect_process(delta):
	if next_state == "":
		dragon.model.global_position.y = last_y_pos + .2 * (1.0 + sin(9.0 * Time.get_ticks_msec() * .001))


