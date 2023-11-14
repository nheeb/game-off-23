extends Node3D

signal hint_can_fade

const FLASH_DURATION = .5

func _ready():
	$AnimationPlayer.connect("animation_finished", on_animation_finished)
	
func on_animation_finished(_anim):
	queue_free()
	emit_signal("hint_can_fade")

