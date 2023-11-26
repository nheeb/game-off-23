extends DragonState

func get_probability() -> float:
	return 100.03

const RISE_TIME = 2.7

const AIR = preload("res://Objects/Effects/CircularAir.tscn")

func effect_start(index):
	dragon.body_direction_target_node = Game.player
	dragon.turn_type = Dragon.TurnType.FOLLOW
	dragon.angular_speed *= .4
	dragon.is_flying = true
	var start_pos := dragon.global_position
	get_tree().create_tween().tween_property(dragon, "position:y", dragon.FLY_HEIGHT, RISE_TIME)
	await get_tree().create_timer(.7).timeout
	var air := AIR.instantiate()
	Game.world.add_child(air)
	air.global_position = start_pos
	dragon.air_knockback_area.activate()
	await get_tree().create_timer(RISE_TIME).timeout
	next_state = "Idle"

func effect_process(delta):
	pass


