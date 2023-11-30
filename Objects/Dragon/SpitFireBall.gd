extends DragonState

const MIN_DIST = 12.0
const FIRE_BALL = preload("res://Objects/Projectiles/Fireball.tscn")
const ATTACK_HINT_BALL = preload("res://Objects/Effects/AttackHintFallingDebris.tscn")

func get_probability() -> float:
	return 0.28 if dragon.player_distance >= MIN_DIST and dragon.player_in_sight else 0.0

@export var fireball_sound : Array

func effect_start(index):
	dragon.turn_type = Dragon.TurnType.TURN
	dragon.body_direction_target_position = Game.player.global_position
	await get_tree().create_timer(1.0).timeout
	if not is_active(): return
	dragon.animations.is_spitting_fire = true
	%AudioDragonHead.stream = fireball_sound.pick_random()
	%AudioDragonHead.play()
	var fire_ball = FIRE_BALL.instantiate()
	Game.world.add_child(fire_ball)
	fire_ball.start(dragon.head_position.global_position, Game.player.global_position)
	var hint = ATTACK_HINT_BALL.instantiate()
	Game.world.add_child(hint)
	hint.size = 5
	hint.global_position = Functions.get_nearest_ground(Game.player.global_position)
	var hint_normal = Functions.get_nearest_ground_normal(Game.player.global_position)
	Functions.align_node(hint, Vector3.UP, hint_normal)
	fire_ball.fireball_explode.connect(hint.queue_free)
	await get_tree().create_timer(2.0).timeout
	dragon.animations.is_spitting_fire = false
	if is_active(index): next_state = "Idle"

func effect_process(delta):
	pass

