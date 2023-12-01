extends DragonState

const MIN_DIST = 5.0
const MAX_DIST = 17.0
const FIRE_CONE = preload("res://Objects/Projectiles/Firecone.tscn")
const HINT = preload("res://Objects/Effects/AttackHintFireCone.tscn")

const cone_offset = Vector3.DOWN * 0.1

func get_probability() -> float:
	return 0.2 if dragon.player_distance >= MIN_DIST and dragon.player_distance <= MAX_DIST else 0.0

@export var firecone_sound : Array
func effect_start(index):
#	%AudioDragonHead.stream = fireball_sound.pick_random()
#	%AudioDragonHead.play()
	dragon.animations.is_flying = false
	dragon.turn_type = Dragon.TurnType.TURN
	dragon.body_direction_target_position = Game.player.global_position
	await dragon.turn_done
	var hint = HINT.instantiate()
	Game.world.add_child(hint)
	hint.global_position = dragon.head_position.global_position + cone_offset
	hint.global_rotation = dragon.head_position.global_rotation
	await get_tree().create_timer(.6).timeout
	%AudioDragonHead.stream = firecone_sound.pick_random()
	%AudioDragonHead.play()
	dragon.animations.is_spitting_fire = true
	var fire_cone = FIRE_CONE.instantiate()
	Game.world.add_child(fire_cone)
	fire_cone.global_position = dragon.head_position.global_position + cone_offset
	fire_cone.global_rotation = dragon.head_position.global_rotation
	fire_cone.hint_can_fade.connect(hint.start_closing)
	await get_tree().create_timer(1.1).timeout
	dragon.animations.is_spitting_fire = false
	next_state = "Idle"

func effect_process(delta):
	pass

