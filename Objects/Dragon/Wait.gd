extends DragonState

var duration := 0.0
var timer := 0.0

func get_probability() -> float:
	return 0.1

func effect_start(index):
	if randi() % 2 == 0:
		dragon.turn_type = Dragon.TurnType.TURN
		dragon.body_direction_target_position = Game.player.global_position
	duration = [0.8, 2.0, 3.5].pick_random()
	timer = duration

func effect_process(delta):
	timer -= delta
	if timer <= 0.0:
		next_state = "Idle"

