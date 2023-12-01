extends Node

func remove_y_value(pos: Vector3) -> Vector3:
	pos.y = 0.0
	return pos

func no_y_normalized(vec: Vector3) -> Vector3:
	return remove_y_value(vec).normalized()

func y_plane_dist(pos1: Vector3, pos2: Vector3) -> float:
	return remove_y_value(pos1).distance_to(remove_y_value(pos2))

func clamp_map(value: float, istart: float, istop: float, ostart: float, ostop: float) -> float:
	value = clamp(value, istart, istop)
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))

func get_nearest_ground(pos: Vector3, padding: float = .35) -> Vector3:
	$GroundFeeler.global_position = pos
	$GroundFeeler.target_position = Vector3.DOWN * 100.0
	$GroundFeeler.force_raycast_update()
	return $GroundFeeler.get_collision_point() + Vector3.UP * padding

func get_nearest_ground_normal(pos: Vector3) -> Vector3:
	$GroundFeeler.global_position = pos
	$GroundFeeler.target_position = Vector3.DOWN * 100.0
	$GroundFeeler.force_raycast_update()
	return $GroundFeeler.get_collision_normal()

func align_node(node: Node3D, local_direction: Vector3, target_global_direction: Vector3):
	var current_global_direction := node.global_position.direction_to(node.to_global(local_direction))
	var cross_direction := current_global_direction.cross(target_global_direction).normalized()
	if cross_direction.is_normalized():
		var rotation_angle := current_global_direction.signed_angle_to(target_global_direction, cross_direction)
		node.rotate(cross_direction, rotation_angle)

func recursive_set_light_layers(node: Node, layers: int):
	for c in node.get_children():
		recursive_set_light_layers(c, layers)
		if c is VisualInstance3D:
			c.layers = layers

func spawn_instance(packed_scene: PackedScene, position: Vector3, parent: Node = null) -> Node3D:
	var new_obj = packed_scene.instantiate()
	if parent == null:
		Game.world.add_child(new_obj)
	else:
		parent.add_child(new_obj)
	new_obj.global_position = position
	return new_obj

func _ready():
	pass
