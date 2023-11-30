extends DragonState

func get_probability() -> float:
	return 0.0

func effect_start(index):
	call_deferred("orchestrate")

func orchestrate():
	dragon.animations.is_roaring = true
	await get_tree().create_timer(5.0).timeout
	dragon.animations.is_roaring = false

func effect_process(delta):
	pass


