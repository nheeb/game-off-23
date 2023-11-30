extends Node3D

signal hint_can_fade

const FLASH_DURATION = .5

func _ready():
	$AnimationPlayer.connect("animation_finished", on_animation_finished)
	await get_tree().create_timer(1).timeout
	emit_signal("hint_can_fade")
	
func on_animation_finished(_anim):
	queue_free()


