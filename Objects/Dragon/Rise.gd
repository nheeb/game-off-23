extends DragonState

func get_probability() -> float:
	return 0.03

const RISE_TIME = 2.7

func effect_start(index):
	dragon.body_direction_target_node = Game.player
	dragon.turn_type = Dragon.TurnType.FOLLOW
	dragon.angular_speed *= .4
	dragon.is_flying = true
	get_tree().create_tween().tween_property(dragon.model, "position:y", dragon.FLY_HEIGHT, RISE_TIME)
	dragon.air_knockback_area.activate()
	await get_tree().create_timer(RISE_TIME).timeout
	next_state = "Idle"

func effect_process(delta):
	pass


