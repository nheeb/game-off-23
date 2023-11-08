extends DragonState

const HIGH_DIST_MIN = 16.0
const HIGH_DIST_MAX = 28.0

const STOP_DIST = 8.0
const MAX_DURATION = 5.0

var timer := 0.0

func get_probability() -> float:
	return Functions.clamp_map(dragon.player_distance, HIGH_DIST_MIN, HIGH_DIST_MAX, 0.0, 0.35)

func effect_start(index):
	timer = MAX_DURATION

func effect_process(delta):
	dragon.movement_target_position = Game.player.global_position
	timer -= delta
	if timer <= 0.0 or dragon.global_position.distance_to(Game.player.global_position) < STOP_DIST:
		next_state = "Idle"

