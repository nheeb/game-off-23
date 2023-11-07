extends Node

@onready var state_name = self.name
@onready var dragon : Dragon = get_parent().get_parent()

const HIGH_DIST_MIN = 16.0
const HIGH_DIST_MAX = 28.0

const STOP_DIST = 8.0
const MAX_DURATION = 5.0

var timer := 0.0

func get_probability() -> float:
	return Functions.clamp_map(dragon.player_distance, HIGH_DIST_MIN, HIGH_DIST_MAX, 0.0, 0.35)

func effect_start():
	timer = MAX_DURATION

func effect_process(delta):
	dragon.movement_target_position(Game.player.global_position)
	timer -= delta
	if timer <= 0.0 or dragon.global_position.distance_to(Game.player.global_position) < STOP_DIST:
		next_state = "Idle"

var next_state = ""
func get_next_state():
	var value = next_state
	next_state = ""
	return next_state

func is_active():
	return dragon.current_state_object == self

