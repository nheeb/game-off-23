extends DragonState

const MIN_DIST = 12.0
const FIRE_BALL = preload("res://Objects/Projectiles/Fireball.tscn")
const ATTACK_HINT_BALL = preload("res://Objects/Effects/AttackHintFallingDebris.tscn")

func get_probability() -> float:
	return 0.28 if dragon.player_distance >= MIN_DIST and dragon.player_in_sight else 0.0

@export var fireball_sound : Array
@export var radial_fire_sound : Array
@export var hit_ground_sound : Array

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
	fire_ball.call_reference = self
	fire_ball.start(dragon.head_position.global_position, Game.player.global_position)
	var hint = ATTACK_HINT_BALL.instantiate()
	Game.world.add_child(hint)
	hint.size = 5
	hint.global_position = Functions.get_nearest_ground(Game.player.global_position)
	var hint_normal = Functions.get_nearest_ground_normal(Game.player.global_position)
	Functions.align_node(hint, Vector3.UP, hint_normal)
	fire_ball.fireball_explode.connect(hint.queue_free)
	await get_tree().create_timer(2.0).timeout
#	%AudioFireball.stream = ground_hit_sound.pick_random()
#	%AudioStreamPlayer3D.stream = radial_fire_sound.pick_random()
#	%AudioFireball.play()
#	%AudioStreamPlayer3D.play()
	dragon.animations.is_spitting_fire = false
	if is_active(index): next_state = "Idle"

func effect_process(delta):
	pass

var latest_used_audio_player : int = 0 :
	set(value):
		latest_used_audio_player = value % 5
		
func play_ground_hit_sound():
	if (latest_used_audio_player == 0):
			%AudioFireball.stream = hit_ground_sound.pick_random()
			%AudioFireball.play()
	if (latest_used_audio_player == 1):
			%AudioFireball2.stream = hit_ground_sound.pick_random()
			%AudioFireball2.play()
	if (latest_used_audio_player == 2):
			%AudioFireball3.stream = hit_ground_sound.pick_random()
			%AudioFireball3.play()
	if (latest_used_audio_player == 3):
			%AudioStreamPlayer3D.stream = hit_ground_sound.pick_random()
			%AudioStreamPlayer3D.play()
	if (latest_used_audio_player == 4):
			%AudioStreamPlayer3D2.stream = hit_ground_sound.pick_random()
			%AudioStreamPlayer3D2.play()
	latest_used_audio_player += 1
