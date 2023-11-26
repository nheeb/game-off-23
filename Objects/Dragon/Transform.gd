extends DragonState

func get_probability() -> float:
	return 0.0

func get_z_relative_to_dragon(node: Node3D) -> float:
	return dragon.to_local(node.global_position).z

func effect_start(index):
	await get_tree().create_timer(1.0).timeout
	dragon.colors.transition_to_stage(dragon.stage, 4.0)
	
	var z_start := get_z_relative_to_dragon(dragon.head_position)
	var z_end := get_z_relative_to_dragon(dragon.tail_position)
	
	for scale_mesh in dragon.scale_meshes:
		var tween := get_tree().create_tween()
		tween.tween_interval(Functions.clamp_map(get_z_relative_to_dragon(scale_mesh), z_start, z_end, 1.0, 4.0))
		tween.tween_callback(func (): scale_mesh.visible = true; scale_mesh.scale = Vector3.ONE * .1)
		tween.tween_property(scale_mesh, "scale", Vector3.ONE, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	await get_tree().create_timer(1.5).timeout
	dragon.revive_hp()
	await get_tree().create_timer(4.5).timeout
	
	next_state = "Idle"

func effect_process(delta):
	pass


