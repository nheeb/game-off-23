extends Node3D

var origin_pos : Vector3
var target_pos : Vector3
var fly_time := 2.0
var curve_height := 3.0

@export var fly_curve: Curve
@export var show_danger_zone := false

const EXPLOSION = preload("res://Objects/Effects/Explosion.tscn")

var timer := 0.0

func start(_origin_pos, _target_pos):
	origin_pos = _origin_pos
	global_position = origin_pos
	target_pos = _target_pos
	if show_danger_zone:
		pass #TODO danger zone

func _physics_process(delta):
	timer += delta
	if timer >= fly_time or $CollisionDetector.has_overlapping_bodies():
		explode()
	else:
		var progress_normalized : float = clamp(timer / fly_time, 0.0, 1.0)
		global_position = lerp(origin_pos, target_pos, progress_normalized) + fly_curve.sample_baked(progress_normalized) * curve_height

func explode():
	var explosion = EXPLOSION.instantiate()
	explosion.global_position = global_position
	queue_free()
