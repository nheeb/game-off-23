extends Node3D

func _ready():
	await get_tree().create_timer(.1).timeout
	Game.player.get_node("Magic").emitting = true
	$Pivot/HealEffect.emitting = true
	await get_tree().create_timer(2.8).timeout
	queue_free()
