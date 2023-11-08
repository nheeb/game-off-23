extends DragonState

func get_probability() -> float:
	if dragon.player_distance <= 4.2 and dragon.player_face_angle < 40.0:
		return .5
	else:
		return 0.0

func effect_start(index):
	await get_tree().create_timer(1.0).timeout
	dragon.bite_area.activate()
	await get_tree().create_timer(.8).timeout
	dragon.bite_area.activate()
	await get_tree().create_timer(.8).timeout
	dragon.bite_area.activate()
	await get_tree().create_timer(1.2).timeout
	if is_active():
		next_state = "Idle"

func effect_process(delta):
	pass
