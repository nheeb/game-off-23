class_name Projectile extends Node3D

@onready var rotation_point = $RotationPoint

var target_position: Vector3 = Vector3.ZERO
var source_position: Vector3 = Vector3.ZERO
var control_point: Vector3 = Vector3.ZERO
var control_point_return: Vector3 = Vector3.ZERO

var progress: float = 0.0
var path_time: float = 1.0
var is_returning: bool = false

var projectile_scene = preload("res://Objects/Pickups/ThrownSwordPickup.tscn")

func _process(delta):
	rotation_point.rotation.y += delta * PI * 3

func _physics_process(delta):
	progress += delta / path_time
	
	if progress >= 1.0:
		if not is_returning:
			start_return()
		else:
			drop()
			return
	
	var target_position_for_tick = quadratic_bezier(source_position, control_point, target_position, progress)
	var space_state = get_world_3d().direct_space_state
	
	if progress > 0.4:
		var query = PhysicsRayQueryParameters3D.create(global_position, target_position_for_tick)
		query.collision_mask = 3
		var result = space_state.intersect_ray(query)
		if result:
			drop(target_position_for_tick - global_position)
			return
	global_position = target_position_for_tick
	
func drop(direction: Vector3 = Vector3.ZERO):
	var pickup = projectile_scene.instantiate()
	pickup.position = global_position
	get_tree().root.add_child(pickup)
	if direction != Vector3.ZERO:
		pickup.look_at(global_position + direction)
	else:
		pickup.rotation_degrees.x = -90
	queue_free()

func start_return():
	var tmp = source_position
	var tmp_control = control_point
	source_position = target_position
	target_position = tmp
	control_point = control_point_return
	control_point_return = control_point
	progress = 0.0
	is_returning = true

func quadratic_bezier(p0: Vector3, p1: Vector3, p2: Vector3, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r 
