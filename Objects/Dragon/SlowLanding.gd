extends DragonState

func get_probability() -> float:
	return 0.1

const LANDING_TIME = 2.7
func effect_start(index):
	get_tree().create_tween().tween_property(dragon.model, "position:y", 0.0, LANDING_TIME)
	await get_tree().create_timer(LANDING_TIME/2.0).timeout
	dragon.air_knockback_area.activate()
	await get_tree().create_timer(LANDING_TIME/2.0).timeout
	dragon.is_flying = false
	next_state = "Idle"

func effect_process(delta):
	pass


