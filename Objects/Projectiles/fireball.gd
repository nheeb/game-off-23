extends Node3D

@onready var die_in = 2

func _process(delta):
	die_in -= delta
	if die_in <=0:
		queue_free()
	transform.origin.z += delta*10
