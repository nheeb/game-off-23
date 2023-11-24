extends Node3D

func _ready():
	await get_tree().create_timer(2.8).timeout
	queue_free()
