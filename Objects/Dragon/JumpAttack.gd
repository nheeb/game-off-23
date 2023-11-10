extends DragonState

const MIN_DIST = 9.0
const DIST_TO_PLAYER = 1.9
const JUMP_HEIGHT = 2.0

@export var jump_curve : Curve

func _ready():
	jump_curve.bake()

func get_probability() -> float:
	if dragon.player_in_sight and dragon.player_distance > MIN_DIST:
		return 0.1
	else:
		return 0.0

func effect_start(index):
	dragon.turn_type = Dragon.TurnType.FOLLOW
	get_tree().create_tween().tween_property(dragon.model, "rotation_degrees:x", -20, 1.0)
	await get_tree().create_timer(1.7).timeout
	dragon.analyse_battlefield()
	if dragon.player_in_sight and is_active(index):
		var landing_pos = Game.player.global_position + Functions.no_y_normalized(Game.player.global_position.direction_to(dragon.global_position)) * DIST_TO_PLAYER
		var jump_time = dragon.player_distance * .1
		var tween := get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property(dragon, "global_position:x", landing_pos.x, jump_time)
		tween.tween_property(dragon, "global_position:z", landing_pos.z, jump_time)
		tween.tween_method(func (progress): dragon.global_position.y = jump_curve.sample_baked(progress) * JUMP_HEIGHT, 0.0, 1.0, jump_time)
		await tween.finished
		dragon.jump_landing_area.activate()
	get_tree().create_tween().tween_property(dragon.model, "rotation_degrees:x", 0, .5)
	await get_tree().create_timer(.5).timeout
	if is_active(index):
		next_state = "Idle"

func effect_process(delta):
	pass


