extends Node3D

signal spell_cast

func signal_spell_cast(): spell_cast.emit()

func _physics_process(delta):
	global_position = Game.player.global_position + Vector3.UP * 3.0
