extends DragonState

func get_probability() -> float:
	return 0.0

func effect_start(index):
	dragon.animations.is_flying = false
	pass

func effect_process(delta):
	pass


