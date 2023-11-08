extends DragonState

func get_probability() -> float:
	return 0.0

func effect_start(index: int):
	dragon.reset_behaviour()
	dragon.analyse_battlefield()
	dragon.choose_action()

func effect_process(delta: float):
	pass

