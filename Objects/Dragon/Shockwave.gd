extends DragonState

const MIN_DIST = 5.0
const MAX_DIST = 10.0
const FIRE_CONE = preload("res://Objects/Projectiles/Shockwave.tscn")
const HINT = preload("res://Objects/Effects/AttackHintFireCone.tscn")

@export var radialfire_sound : Array 

func get_probability() -> float:
	return 0.3 if dragon.player_distance >= MIN_DIST and dragon.player_distance <= MAX_DIST else 0.0

func effect_start(index):
	dragon.animations.is_flying = false
	dragon.turn_type = Dragon.TurnType.TURN
	dragon.body_direction_target_position = Game.player.global_position
	await dragon.turn_done
	await get_tree().create_timer(.6).timeout
	%AudioDragonHead.stream = radialfire_sound.pick_random()
	%AudioDragonHead.play()
	var fire_cone = FIRE_CONE.instantiate()
	Game.world.add_child(fire_cone)
	fire_cone.global_position = dragon.head_position.global_position + Vector3.DOWN * 1.2
	fire_cone.global_rotation = dragon.head_position.global_rotation
	await get_tree().create_timer(1.1).timeout
	next_state = "Idle"

func effect_process(delta):
	pass

