extends DragonState


@export var sound_impact : Array

func get_probability() -> float:
	if dragon.player_distance <= 6.2 and dragon.player_face_angle > 120.0:
		return .4
	else:
		return 0.0

func effect_start(index):
	dragon.animations.is_flying = false
	await get_tree().create_timer(0.8).timeout
	dragon.tail_area.activate()
	%AudioDragonBody.stream = sound_impact.pick_random()
	%AudioDragonBody.play()
	await get_tree().create_timer(2.2).timeout
	if is_active():
		next_state = "Idle"

func effect_process(delta):
	pass
