extends DragonState

const MIN_DIST = 5.0
const MAX_DIST = 17.0
const FIRE_CONE = preload("res://Objects/Projectiles/Firecone.tscn")
const HINT = preload("res://Objects/Effects/AttackHintFireCone.tscn")

func get_probability() -> float:
	return 0.2 if dragon.player_distance >= MIN_DIST and dragon.player_distance <= MAX_DIST else 0.0

func effect_start(index):
	dragon.turn_type = Dragon.TurnType.TURN
	dragon.body_direction_target_position = Game.player.global_position
	await dragon.turn_done
	var hint = HINT.instantiate()
	Game.world.add_child(hint)
	hint.global_position = Functions.get_nearest_ground(dragon.head_position.global_position)
	hint.global_rotation = dragon.head_position.global_rotation
	await get_tree().create_timer(1.0).timeout
	var fire_cone = FIRE_CONE.instantiate()
	Game.world.add_child(fire_cone)
	fire_cone.global_position = dragon.head_position.global_position
	fire_cone.global_rotation = dragon.head_position.global_rotation
	fire_cone.hint_can_fade.connect(hint.start_closing)
	await get_tree().create_timer(1.1).timeout
	next_state = "Idle"

func effect_process(delta):
	pass

