extends DragonState

func get_probability() -> float:
	return 0.0

func get_z_relative_to_dragon(node: Node3D) -> float:
	return dragon.to_local(node.global_position).z

const PICKUP_CARROT = preload("res://Objects/Pickups/CarrotPickup.tscn")
func effect_start(index):
	dragon.is_flying = false
	dragon.animations.is_flying = false
	
	await get_tree().create_timer(1.0).timeout
	dragon.colors.transition_to_stage(dragon.stage, 4.0)
	
	var z_start := get_z_relative_to_dragon(dragon.head_position)
	var z_end := get_z_relative_to_dragon(dragon.tail_position)
	
	for scale_mesh in dragon.scale_meshes:
		var tween := get_tree().create_tween()
		tween.tween_interval(Functions.clamp_map(get_z_relative_to_dragon(scale_mesh), z_start, z_end, 1.0, 4.0))
		tween.tween_callback(func (): scale_mesh.visible = true; scale_mesh.scale = Vector3.ONE * .1)
		tween.tween_property(scale_mesh, "scale", Vector3.ONE, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	dragon.animations.reset()
	await get_tree().create_timer(1.5).timeout
	dragon.revive_hp()
	dragon.animations.is_roaring = true
	for i in range(3):
		await get_tree().create_timer(.7).timeout
		var pos = Game.dragon.global_position + Vector3.UP + 6 * Vector3.RIGHT.rotated(Vector3.UP, i*2*PI/3.0)
		pos = Functions.get_nearest_ground(pos) + Vector3.UP * 2.0
		var pickup: CarrotPickup = PICKUP_CARROT.instantiate()
		get_tree().get_root().add_child(pickup)
		pickup.transform = Transform3D(Basis(), pos)
	await get_tree().create_timer(2.5).timeout
	dragon.animations.is_roaring = false
	next_state = "Idle"

func effect_process(delta):
	pass


