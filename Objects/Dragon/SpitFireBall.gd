extends Node

@onready var state_name = self.name
@onready var dragon : Dragon = get_parent().get_parent()

const MIN_DIST = 10.0
const FIRE_BALL = preload("res://Objects/Projectiles/Fireball.tscn")

func get_probability() -> float:
	return 0.25 if dragon.player_distance >= MIN_DIST else 0.0

func effect_start():
	await get_tree().create_timer(1.0).timeout
	if not is_active(): return
	var fire_ball = FIRE_BALL.instantiate()
	Game.world.add_child(fire_ball)
	fire_ball.start(dragon.head_position.global_position, Game.player.global_position)
	await get_tree().create_timer(2.0).timeout
	if is_active(): next_state = "Idle"

func effect_process(delta):
	pass

var next_state = ""
func get_next_state():
	var value = next_state
	next_state = ""
	return next_state

func is_active():
	return dragon.current_state_object == self

