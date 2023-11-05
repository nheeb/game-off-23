class_name HealthSystem extends Node

var health = 0
var invulnerable_time_remaining = 0.0

signal damage_taken
signal death

@export var max_health = 5
@export var after_hit_invulnerability_duration: float = 1.5

func _ready():
	health = max_health

func _physics_process(delta):
	if invulnerable_time_remaining > 0.0:
		invulnerable_time_remaining -= delta
	
func take_damage():
	invulnerable_time_remaining = after_hit_invulnerability_duration
	emit_signal("damage_taken")
	health -= 1
	health = max(0, health)
	if health == 0:
		emit_signal("death")
	
func can_take_damage():
	return invulnerable_time_remaining <= 0.0
