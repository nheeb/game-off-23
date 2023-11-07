extends Node3D

@export var damage := 40

func _ready():
	$Particles.emitting = true
	$Particles2.emitting = true
	$Particles3.emitting = true
	var tween := get_tree().create_tween()
	tween.tween_property($OmniLight, "light_energy", 0.0, .8)
	tween.tween_interval(2.0)
	tween.tween_callback(self.queue_free)

