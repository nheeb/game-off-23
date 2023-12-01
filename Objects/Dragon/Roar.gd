extends DragonState

func get_probability() -> float:
	return 0.1

const BOULDER = preload("res://Objects/Projectiles/Boulder.tscn")
const ROAR_EFFECT = preload("res://Objects/Effects/RoarEffect.tscn")

@export var roar_sound : Array
@export var boulder_sound : Array
@export var hit_ground_sound : Array

var last_y_pos: float
func effect_start(index):
	dragon.animations.is_flying = false
	dragon.animations.is_roaring = true
	%AudioDragonHead.stream = roar_sound.pick_random()
	%AudioDragonHead.play()
	Functions.spawn_instance(ROAR_EFFECT, dragon.head_position.global_position, dragon.head_position_2)
	last_y_pos = dragon.model.global_position.y
	Game.main_cam.screen_shake()
	await get_tree().create_timer(1.5).timeout
	for i in range(randi_range(3, 5)):
		await get_tree().create_timer(randf_range(.2, .8)).timeout
		var boulder = BOULDER.instantiate()
		boulder.roar_reference = self
		Game.world.add_child(boulder)
		boulder.fall_down(dragon.global_position + Vector3(randf_range(-1, 1) * 13.0, 5.0, randf_range(-1, 1) * 13.0))
		if (i % 3 == 0):
			%AudioFireball.stream = boulder_sound.pick_random()
			%AudioFireball.play()
		if (i % 3 == 1):
			%AudioFireball2.stream = boulder_sound.pick_random()
			%AudioFireball2.play()
		if (i % 3 == 2):
			%AudioFireball3.stream = boulder_sound.pick_random()
			%AudioFireball3.play()
		if (i % 3 == 3):
			%AudioStreamPlayer3D.stream = boulder_sound.pick_random()
			%AudioStreamPlayer3D.play()
		if (i % 3 == 4):
			%AudioStreamPlayer3D2.stream = boulder_sound.pick_random()
			%AudioStreamPlayer3D2.play()
	await get_tree().create_timer(1).timeout
	dragon.animations.is_roaring = false
	if is_active(index):
		next_state = "Idle"
		dragon.model.global_position.y = last_y_pos

func effect_process(delta):
	if next_state == "":
		dragon.model.global_position.y = last_y_pos + .2 * (1.0 + sin(9.0 * Time.get_ticks_msec() * .001))

var latest_used_audio_player : int = 0 :
	set(value):
		latest_used_audio_player = value % 5
func play_dawnfall_sound():
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
	

