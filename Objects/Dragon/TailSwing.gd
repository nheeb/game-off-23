extends DragonState

func get_probability() -> float:
	if dragon.player_distance <= 6.2 and dragon.player_face_angle > 120.0:
		return .6
	else:
		return 0.0

func effect_start(index):
	await get_tree().create_timer(1.2).timeout
	dragon.tail_area.activate()
	await get_tree().create_timer(2.2).timeout
	if is_active():
		next_state = "Idle"

func effect_process(delta):
	pass
