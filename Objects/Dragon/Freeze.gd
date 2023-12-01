extends DragonState

@export var sound_freeeze : Array

func get_probability() -> float:
	return 0.0

func effect_start(index):
	dragon.is_flying = false
	%AudioDragonBody.stream = sound_freeeze.pick_random()
	%AudioDragonBody.play()
	var tween := get_tree().create_tween()
	tween.tween_property(dragon.colors, "freeze_effect", 1.0, 1.0).from(0.0)
	await get_tree().create_timer(5).timeout
	tween = get_tree().create_tween()
	tween.tween_property(dragon.colors, "freeze_effect", 0.0, 1.0).from(1.0)
	await get_tree().create_timer(.5).timeout
	next_state = "Idle"

func effect_process(delta):
	pass


