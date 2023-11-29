extends DragonState

func get_probability() -> float:
	return 0.1

var max_duration := 0.0
var timer := 0.0

const DISTANCE_TO_WALL = 3.5
const MIN_DIST = 4.0

func effect_start(index):
	max_duration = 3.0 + randf() * 2.0
	timer = max_duration
	for i in range(10):
		%AudioDragonWings.stream = Game.dragon.sound_dragon_wing.pick_random()
		%AudioDragonWings.play()
		var random_direction = Vector3.FORWARD.rotated(Vector3.UP, randf() * PI * 2.0)
		var collision_point = dragon.get_nearest_collision(random_direction)
		var target = collision_point - random_direction * DISTANCE_TO_WALL
		if Functions.y_plane_dist(dragon.global_position, target) > MIN_DIST:
			dragon.movement_target_position = target
			dragon.movement_type = Dragon.MovementType.DIRECTIONAL
			return

func effect_process(delta):
	timer -= delta
	if timer <= delta or dragon.movement_type == Dragon.MovementType.STANDING:
		next_state = "Idle"

