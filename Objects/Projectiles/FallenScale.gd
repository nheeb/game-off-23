extends Node3D

const FLOAT_EPSILON = 0.00001
var initial_velocity: Vector3# = random_throw_direction()
@export var gravity_speed : float = 4.0
@export var friction : float = 0.3
@export var ground_level : float = 0.6
@export var throw_speed_variation : float = 3.0
@export var fall_minimum_distance: float = 2.0
@export var rotation_speed: float = 5.0
@export var rotation_speed_variation: float = 2.0
@export var rotation_axis : Vector3 = Vector3.RIGHT
@export var random_velocity_variation : float = 0.3
@onready var final_basis = transform.basis.rotated(Vector3.UP, PI * 2 * randf())

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
	if rotation_axis == Vector3(0,0,0):
		rotation_axis = Vector3.RIGHT
	return v

func activate(direction: Vector3) -> void:
	initial_velocity = direction
	var rng = RandomNumberGenerator.new()
	rotation_speed = rotation_speed+rng.randf_range(-rotation_speed_variation, rotation_speed_variation)
	rotation_axis = (
		rng.randi_range(0, 1)* Vector3.RIGHT +
		rng.randi_range(0, 1)* Vector3.UP +
		rng.randi_range(0, 1)* Vector3.FORWARD
	).normalized()
	if rotation_axis == Vector3(0,0,0):
		rotation_axis = Vector3.RIGHT
	Items.scale_bank[Game.dragon.stage-1] += 1

var falling := true
var contracting := false
var shrinking := false
var contract_velocity := 0.0
var contract_direction: Vector3
const CONTRACT_ACCEL = 2.0
const CONTRACT_MAX_DIST = 2.6
const CONTRACT_MAX_VELOCITY = 5.8
const CONTRACT_WAIT_FACTOR = .04
func _physics_process(delta):
	if falling:
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
			falling = false
	if contracting:
		contract_velocity += delta * CONTRACT_ACCEL
		contract_velocity = min(contract_velocity, CONTRACT_MAX_VELOCITY)
		global_position += contract_direction * contract_velocity * delta
		if Game.player.global_position.distance_to(global_position) <= CONTRACT_MAX_DIST and not shrinking:
			shrinking = true
			var tween := get_tree().create_tween()
			tween.tween_property(self, "scale", Vector3.ONE*.2, .35)
			tween.tween_callback(queue_free)

func start_contracting():
	var dist_to_player : float = Game.player.global_position.distance_to(global_position)
	await get_tree().create_timer(dist_to_player * CONTRACT_WAIT_FACTOR).timeout
	contracting = true
	contract_direction = Functions.no_y_normalized(global_position.direction_to(Game.player.global_position))

func _ready():
	match Game.dragon.stage:
		1:
			$Plane.set_surface_override_material(1, Game.dragon.colors.fallen_mat_scale_1)
			$Plane.set_surface_override_material(0, Game.dragon.colors.fallen_mat_yolk_1)
		2:
			$Plane.set_surface_override_material(1, Game.dragon.colors.fallen_mat_scale_2)
			$Plane.set_surface_override_material(0, Game.dragon.colors.fallen_mat_yolk_2)
		3:
			$Plane.set_surface_override_material(1, Game.dragon.colors.fallen_mat_scale_3)
			$Plane.set_surface_override_material(0, Game.dragon.colors.fallen_mat_yolk_3)
