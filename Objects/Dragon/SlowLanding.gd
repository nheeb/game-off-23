extends DragonState

func get_probability() -> float:
	var has_made_air_attack : bool = dragon.state_history[-1] in ["AirFireBalls", "AirGrab", "AirFireCone"]
	return 0.1 if has_made_air_attack else .01

const AIR = preload("res://Objects/Effects/CircularAir.tscn")

const LANDING_TIME = 2.7
func effect_start(index):
	get_tree().create_tween().tween_property(dragon, "global_position", Functions.get_nearest_ground(dragon.global_position), LANDING_TIME)
	await get_tree().create_timer(LANDING_TIME/2.0).timeout
	dragon.air_knockback_area.activate()
	var air := AIR.instantiate()
	Game.world.add_child(air)
	air.global_position = Functions.get_nearest_ground(dragon.global_position)
	await get_tree().create_timer(LANDING_TIME/2.0).timeout
	dragon.is_flying = false
	next_state = "Idle"

func effect_process(delta):
	pass


