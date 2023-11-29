extends DragonState

func get_probability() -> float:
	return 0.1

var duration := 0.0
var timer := 0.0

const DURATION_PLAYER_MAX_DIST = 17.0
const FIRE_BALL = preload("res://Objects/Projectiles/Fireball.tscn")
const ATTACK_HINT_BALL = preload("res://Objects/Effects/AttackHintFallingDebris.tscn")

func effect_start(index):
	duration = 2.3 + min(1.0, dragon.player_distance / DURATION_PLAYER_MAX_DIST) * 2.0
	timer = duration
	dragon.movement_type = Dragon.MovementType.CURVED_CLOCKWISE if randi() % 2 == 0 else Dragon.MovementType.CURVED_COUNTERCLOCKWISE
	dragon.turn_type = Dragon.TurnType.FOLLOW
	dragon.body_direction_target_node = Game.player

	for i in range(3 if dragon.stage >= 1 else 5):
		await get_tree().create_timer(.8).timeout
		var target_pos := Functions.no_y_normalized(Game.player.get_motion().last_frame_global_movement) * 4.5 + Game.player.global_position
		var fire_ball = FIRE_BALL.instantiate()
		Game.world.add_child(fire_ball)
		fire_ball.start(dragon.head_position.global_position, target_pos)
		var hint = ATTACK_HINT_BALL.instantiate()
		Game.world.add_child(hint)
		hint.size = 5
		hint.global_position = Functions.get_nearest_ground(target_pos)
		var hint_normal = Functions.get_nearest_ground_normal(target_pos)
		Functions.align_node(hint, Vector3.UP, hint_normal)
		fire_ball.fireball_explode.connect(hint.queue_free)


func effect_process(delta):
	dragon.movement_pivot_position = Game.player.global_position
	timer -= delta
	if timer <= 0.0:
		next_state = "Idle"

