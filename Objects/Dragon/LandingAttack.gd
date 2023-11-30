extends DragonState

func get_probability() -> float:
	var has_made_air_attack : bool = dragon.state_history[-1] in ["AirFireBalls", "AirGrab", "AirFireCone"]
	if not dragon.player_in_sight:
		return 0.0
	return 0.15 if has_made_air_attack else .04

const DIST_TO_PLAYER = 2.3
@export var sound_impact : Array

func effect_start(index):
	dragon.animations.is_flying = false
	%AudioDragonWings.stream = Game.dragon.sound_dragon_wing.pick_random()
	%AudioDragonWings.play()
	dragon.is_flying = false
	var landing_time = dragon.player_distance * .13
	var landing_pos = Game.player.global_position + Functions.no_y_normalized(Game.player.global_position.direction_to(dragon.global_position)) * DIST_TO_PLAYER
	
	var tween = get_tree().create_tween()
#	tween.set_parallel()
#	tween.tween_property(dragon.model, "position:y", 0.0, landing_time)
	tween.tween_property(dragon, "global_position", landing_pos, landing_time)
	
	await tween.finished
	dragon.jump_landing_area.activate()
	
	await get_tree().create_timer(1.1).timeout
	%AudioDragonBody.stream = sound_impact.pick_random()
	%AudioDragonBody.play()
	next_state = "Idle"

func effect_process(delta):
	pass

