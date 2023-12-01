extends DragonState

func get_probability() -> float:
	if dragon.player_distance <= 6.2 and dragon.player_face_angle < 45.0:
		return 0.5
	else:
		return 0.0

func effect_start(index):
	dragon.animations.is_flying = false
	dragon.animations.is_biting = true
	await get_tree().create_timer(1.8).timeout
	dragon.bite_area.activate()
	await get_tree().create_timer(2).timeout
	
	dragon.animations.is_biting = false
	if is_active():
		next_state = "Idle"

func effect_process(delta):
	pass
