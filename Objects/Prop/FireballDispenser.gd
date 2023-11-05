extends Node3D

@export var frequency: float = 3
var last_fireball = 0

func _process(delta):
	last_fireball = max(last_fireball - delta, 0)
	if last_fireball == 0:
		last_fireball = frequency
		add_child(load('res://Objects/Projectiles/fireball.tscn').instantiate())
