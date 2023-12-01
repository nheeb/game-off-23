extends Node3D

@onready var start: Node3D = $CameraStart
@onready var end: Node3D = $CameraEnd
@onready var control: Node3D = $CameraControl
@onready var camera: Camera3D = $Camera3D

@export var path_time: float = 5.0
@export var focus: Node3D

var progress: float = 0.0
signal completed

func activate():
	visible = true
	camera.current = true

func deactivate():
	visible = false
	#camera.current = false
	completed.emit()

func _process(delta):
	if (not visible) or (progress >= 1.0):
		return
	progress += delta / path_time
	camera.global_position = quadratic_bezier(start.global_position, control.global_position, end.global_position, progress)
	camera.look_at(focus.global_position)
	if progress >= 1.0:
		await get_tree().create_timer(2.2).timeout
		deactivate()

func quadratic_bezier(p0: Vector3, p1: Vector3, p2: Vector3, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r 
