extends Node

@onready var state_name = self.name
@onready var dragon : Dragon = get_parent().get_parent()

func get_probability() -> float:
	return 0.2

var duration := 0.0
var timer := 0.0

const DURATION_PLAYER_MAX_DIST = 7.0
const SPEED_MODIFIER = .5

func effect_start():
	duration = .8 + randf() * 1.2 + min(1.0, dragon.player_distance / DURATION_PLAYER_MAX_DIST) * 3.0
	timer = duration
	dragon.movement_type = Dragon.MovementType.CURVED_CLOCKWISE if randi() % 2 == 0 else Dragon.MovementType.CURVED_COUNTERCLOCKWISE
	dragon.body_direction_target = Game.player
	dragon.movement_speed *= SPEED_MODIFIER

func effect_process(delta):
	dragon.movement_pivot_position = Game.player.global_position
	timer -= delta
	if timer <= 0.0:
		next_state = "Idle"

var next_state = ""
func get_next_state():
	var value = next_state
	next_state = ""
	return next_state

func is_active():
	return dragon.current_state_object == self

