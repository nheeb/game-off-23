extends GPUParticles3D

func play():
	emitting = true
	for light in get_children():
		light.visible = true
		var tween := get_tree().create_tween()
		tween.tween_property(light, "light_energy", 2.0, .4).from(0.0)
		tween.tween_property(light, "light_energy", 0.0, .4)
		tween.tween_callback(func (): light.visible = false)
		await get_tree().create_timer(.3).timeout
