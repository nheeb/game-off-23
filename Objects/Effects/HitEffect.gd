extends Node3D

func _ready():
	$AnimatedSprite3D.material_override.set("shader_parameter/rotation", PI * 2.0 * randf())

func _on_animated_sprite_3d_animation_finished():
	queue_free()
