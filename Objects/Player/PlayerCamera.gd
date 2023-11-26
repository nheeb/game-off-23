class_name PlayerCamera extends Node3D

@export var height = 10.0
@export var target_distance_from_player = 4.0
@export var responsivity = 2.0
@export var rotation_responsivity = 1.0
@export var player: Node3D
@export var boss_focus: Node3D
@export var projectile_focus: Node3D

func _ready():
	Game.main_cam = self

func _process(delta):
	global_position = lerp(global_position, getTargetCameraPosition(), delta * responsivity)
	quaternion = quaternion.slerp(getTargetCameraRotation(), delta * rotation_responsivity)
	shake_process(delta)
	
func getFocusPosition():
	if projectile_focus != null:
		return (player.global_position + projectile_focus.global_position) / 2.0
	return player.global_position

func getTargetCameraPosition():
	var camera_backward = get_camera_backward()
	return getFocusPosition() \
		+ camera_backward * target_distance_from_player \
		+ Vector3.UP * height

func getTargetCameraRotation():
	if boss_focus == null:
		return quaternion
	var _transform = Transform3D(Basis(), Functions.remove_y_value(player.global_position)) \
		.looking_at(Functions.remove_y_value(boss_focus.global_position))
	return getTargetCameraRotationTransform().basis.get_rotation_quaternion()

func getTargetCameraRotationTransform():
	return Transform3D(Basis(), global_position) \
		.looking_at(Functions.remove_y_value(player.global_position))

func get_camera_backward():
	if boss_focus != null:
		return Functions.no_y_normalized(player.global_position - boss_focus.global_position)
	return Functions.no_y_normalized(global_transform.basis.z)

@export var noise : FastNoiseLite
var time := 0.0
var trauma := 0.0
var trauma_reduction := .75
var shake_intensity_factor : float
func screen_shake(_trauma: float = 2.0, _shake_intensity: float = .5):
	trauma = max(_trauma, trauma)
	shake_intensity_factor = _shake_intensity

func shake_process(delta):
	if trauma > 0.0:
		trauma = max(trauma - delta * trauma_reduction, 0.0)
		time += delta
		
		%ShakePivot.rotation_degrees.x = 15.0 * get_shake_intensity() * get_noise_from_seed(1)
		%ShakePivot.rotation_degrees.y = 15.0 * get_shake_intensity() * get_noise_from_seed(2)
		%ShakePivot.rotation_degrees.z = 8.0 * get_shake_intensity() * get_noise_from_seed(3)

func get_shake_intensity() -> float:
	return min(trauma, 1.0) * min(trauma, 1.0) * shake_intensity_factor

func get_noise_from_seed(_seed: int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * 50.0)

