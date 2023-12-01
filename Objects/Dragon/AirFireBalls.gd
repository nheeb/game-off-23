extends DragonState

func get_probability() -> float:
	return 0.1

var duration := 0.0
var timer := 0.0

const DURATION_PLAYER_MAX_DIST = 17.0
const FIRE_BALL = preload("res://Objects/Projectiles/Fireball.tscn")
const ATTACK_HINT_BALL = preload("res://Objects/Effects/AttackHintFallingDebris.tscn")

@export var fireball_sound : Array
@export var ground_hit_sound : Array

func effect_start(index):
	dragon.animations.is_flying = true
	duration = 2.3 + min(1.0, dragon.player_distance / DURATION_PLAYER_MAX_DIST) * 2.0
	timer = duration
	dragon.movement_type = Dragon.MovementType.CURVED_CLOCKWISE if randi() % 2 == 0 else Dragon.MovementType.CURVED_COUNTERCLOCKWISE
	dragon.turn_type = Dragon.TurnType.FOLLOW
	dragon.body_direction_target_node = Game.player
	%AudioDragonWings.stream = Game.dragon.sound_dragon_wing.pick_random()
	%AudioDragonWings.play()

	for i in range(3 if dragon.stage >= 1 else 5):
		await get_tree().create_timer(.8).timeout
		if (i % 3 == 0):
			%AudioFireball.stream = fireball_sound.pick_random()
			%AudioFireball.play()
		if (i % 3 == 1):
			%AudioFireball2.stream = fireball_sound.pick_random()
			%AudioFireball2.play()
		if (i % 3 == 2):
			%AudioFireball3.stream = fireball_sound.pick_random()
			%AudioFireball3.play()
		var target_pos := Functions.no_y_normalized(Game.player.get_motion().last_frame_global_movement) * 4.5 + Game.player.global_position
		var fire_ball = FIRE_BALL.instantiate()
		Game.world.add_child(fire_ball)
		fire_ball.call_reference = self
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

var latest_used_audio_player : int = 0 :
	set(value):
		latest_used_audio_player = value % 5
		
func play_ground_hit_sound():
	if (latest_used_audio_player == 0):
			%AudioFireball.stream = ground_hit_sound.pick_random()
			%AudioFireball.play()
	if (latest_used_audio_player == 1):
			%AudioFireball2.stream = ground_hit_sound.pick_random()
			%AudioFireball2.play()
	if (latest_used_audio_player == 2):
			%AudioFireball3.stream = ground_hit_sound.pick_random()
			%AudioFireball3.play()
	if (latest_used_audio_player == 3):
			%AudioStreamPlayer3D.stream = ground_hit_sound.pick_random()
			%AudioStreamPlayer3D.play()
	if (latest_used_audio_player == 4):
			%AudioStreamPlayer3D2.stream = ground_hit_sound.pick_random()
			%AudioStreamPlayer3D2.play()
	latest_used_audio_player += 1
