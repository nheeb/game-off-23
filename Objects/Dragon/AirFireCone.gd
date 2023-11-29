extends DragonState

const MIN_DIST = 12.0
const FIRE_CONE = preload("res://Objects/Projectiles/Firecone.tscn")
const HINT = preload("res://Objects/Effects/AttackHintFireCone.tscn")

var fly_dir: Vector3
@export var sound_fire_cone : Array

func get_probability() -> float:
	return 0.25 if dragon.player_distance >= MIN_DIST else 0.0

func effect_start(index):
	%AudioDragonWings.stream = Game.dragon.sound_dragon_wing.pick_random()
	%AudioDragonWings.play()
	dragon.movement_type = Dragon.MovementType.DIRECTIONAL
	fly_dir = Functions.no_y_normalized(dragon.global_position.direction_to(Game.player.global_position))
	dragon.movement_target_position = dragon.global_position + fly_dir * 50.0
	var hint = HINT.instantiate()
	dragon.head_position.add_child(hint)
	hint.global_position = dragon.head_position.global_position
	hint.global_rotation = dragon.head_position.global_rotation
	hint.rotation_degrees.x = -50
	await get_tree().create_timer(.9).timeout
	var fire_cone = FIRE_CONE.instantiate()
	%AudioDragonHead.stream = sound_fire_cone.pick_random()
	%AudioDragonHead.play()
	dragon.head_position.add_child(fire_cone)
	fire_cone.global_position = dragon.head_position.global_position
	fire_cone.global_rotation = dragon.head_position.global_rotation
	fire_cone.rotation_degrees.x = -50
	fire_cone.hint_can_fade.connect(hint.start_closing)
	await get_tree().create_timer(2.5).timeout
	next_state = "Idle"

func effect_process(delta):
	pass
