extends GPUParticles3D

func play():
	emitting = true
	for light in get_children():
		await get_tree().create_timer(.2).timeout
		light.visible = true
		var tween := get_tree().create_tween()
		tween.tween_property(light, "light_energy", 1.0, .4).from(0.0)
		tween.tween_property(light, "light_energy", 0.0, .4)
		tween.tween_callback(func (): light.visible = false)
