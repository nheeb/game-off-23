extends DragonState

func get_probability() -> float:
	return 0.0

func effect_start(index: int):
	dragon.animations.is_flying = false
	if dragon.first_idle_state:
		dragon.first_idle_state = false
		dragon.refresh_hp()
		await get_tree().create_timer(2).timeout
	dragon.reset_behaviour()
	dragon.analyse_battlefield()
	dragon.choose_action()

func effect_process(delta: float):
	pass

