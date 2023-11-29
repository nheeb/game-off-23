class_name CarrotMissile extends CharacterBody3D

var progress: float = 0.0
var path_time: float = 1.0
var is_returning: bool = false
const speed: float = 12.0

func _ready():
	call_deferred('lifetime')

func lifetime():
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _physics_process(delta):
	global_position = global_position - global_transform.basis.z * speed * delta
	var hit = move_and_collide(- global_transform.basis.z * speed * delta)
	if hit != null:
		queue_free()
