class_name Projectile extends Node3D

@onready var rotation_point = $RotationPoint

var velocity: Vector3 = Vector3.FORWARD

func _ready():
	look_at(global_position + velocity)

func _process(delta):
	rotation_point.rotation.y += delta * PI * 3

func _physics_process(delta):
	var target_pos = global_position + velocity * delta
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(global_position, target_pos)
	var result = space_state.intersect_ray(query)
	if result:
		queue_free()
	else:
		global_position = target_pos