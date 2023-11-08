extends Node3D

const FLOAT_EPSILON = 0.00001
@onready var initial_velocity: Vector3 = random_throw_direction()
@export var gravity_speed : float = 2.0
@export var friction : float = 0.3
@export var ground_level : float = 0.6
@export var throw_speed_variation : float = 3.0
@export var fall_minimum_distance: float = 2.0
@export var rotation_speed: float = 5.0
@export var rotation_speed_variation: float = 2.0
@export var rotation_axis : Vector3 = Vector3.RIGHT
@export var random_velocity_variation : float = 0.3
@onready var final_basis = transform.basis

func random_throw_direction():
	var rng = RandomNumberGenerator.new()
	var direction = rng.randi_range(0, 7)
	var upwards_force = rng.randf_range(1.0, 3.0)
	var v = [
		Vector3(0.0, 0.0, 1.0),
		Vector3(0.5, 0.0, 0.5),
		Vector3(1.0, 0.0, 0.0),
		Vector3(0.5, 0.0, -0.5),
		Vector3(0.0, 0.0, -1.0),
		Vector3(-0.5, 0.0, -0.5),
		Vector3(-1.0, 0.0, 0.0),
		Vector3(-0.5, 0.0, 0.5),
	][direction]
	v = v * (fall_minimum_distance+rng.randf_range(1.0/throw_speed_variation, throw_speed_variation))
	v.y = upwards_force
	v.x += rng.randf_range(-random_velocity_variation, random_velocity_variation)
	v.z += rng.randf_range(-random_velocity_variation, random_velocity_variation)
	rotation_speed = rotation_speed+rng.randf_range(-rotation_speed_variation, rotation_speed_variation)
	rotation_axis = (
		rng.randi_range(0, 1)* Vector3.RIGHT +
		rng.randi_range(0, 1)* Vector3.UP +
		rng.randi_range(0, 1)* Vector3.FORWARD
	).normalized()
	return v

func _physics_process(delta):
	if transform.origin.y > ground_level + FLOAT_EPSILON:
		var fall = initial_velocity * delta
		transform.origin += fall
		initial_velocity *= 1.0-friction*delta
		initial_velocity.y -= gravity_speed*delta
		transform.basis = transform.basis.rotated(rotation_axis, rotation_speed*delta)
	elif transform.origin.y - ground_level < FLOAT_EPSILON:
		transform.origin.y = ground_level
		transform.basis = final_basis
	else:
		get_tree().paused = true
		
