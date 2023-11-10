extends DragonState

func get_probability() -> float:
	if dragon.player_distance <= 5.8 and dragon.player_face_angle > 100.0:
		return .35
	else:
		return 0.0

func effect_start(index):
	pass

func effect_process(delta):
	pass


