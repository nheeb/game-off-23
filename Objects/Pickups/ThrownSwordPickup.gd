extends Node3D


func _ready():
	connect('body_entered', _on_body_entered)


func _on_body_entered(_body):
	Game.player.get_attack_controls().sword_retreived()
	queue_free()
