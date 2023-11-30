extends DragonState

func get_probability() -> float:
	return 0.0

func effect_start(index):
	dragon.reset_behaviour()
	
	dragon.animations.is_dead = true
	#dragon.model.rotate(Vector3.RIGHT,deg_to_rad(180))
	#dragon.model.global_position.y += 1.5

func effect_process(delta):
	pass


