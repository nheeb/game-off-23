extends DragonState

func get_probability() -> float:
	return 0.1

const BOULDER = preload("res://Objects/Projectiles/Boulder.tscn")
const ROAR_EFFECT = preload("res://Objects/Effects/RoarEffect.tscn")

@export var roar_sound : Array

var last_y_pos: float
func effect_start(index):
	%AudioDragonHead.stream = roar_sound.pick_random()
	%AudioDragonHead.play()
	Functions.spawn_instance(ROAR_EFFECT, dragon.head_position.global_position, dragon.head_position)
	last_y_pos = dragon.model.global_position.y
	Game.main_cam.screen_shake()
	await get_tree().create_timer(1.5).timeout
	for i in range(randi_range(3, 5)):
		await get_tree().create_timer(randf_range(.2, .8)).timeout
		var boulder = BOULDER.instantiate()
		Game.world.add_child(boulder)
		boulder.fall_down(dragon.global_position + Vector3(randf_range(-1, 1) * 13.0, 5.0, randf_range(-1, 1) * 13.0))
	await get_tree().create_timer(1).timeout
	if is_active(index):
		next_state = "Idle"
		dragon.model.global_position.y = last_y_pos

func effect_process(delta):
	if next_state == "":
		dragon.model.global_position.y = last_y_pos + .2 * (1.0 + sin(9.0 * Time.get_ticks_msec() * .001))


