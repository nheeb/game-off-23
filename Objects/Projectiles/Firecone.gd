extends Node3D

func _ready():
	var tween := get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($MeshInstance3D.material_override, "shader_parameter/progress", 1.0, .8)
	tween.tween_method(set_collision_polygon_end, 0.0, 1.0, .8)
	tween.chain().tween_interval(1.1)
	tween.chain().tween_callback(queue_free)

const SIZE_X = 3.0
const SIZE_Y = 10.0
func set_collision_polygon_end(progress: float):
	$PlayerDamageArea/CollisionPolygon3D.polygon[1] = progress * Vector2(SIZE_X, SIZE_Y)
	$PlayerDamageArea/CollisionPolygon3D.polygon[2] = progress * Vector2(-SIZE_X, SIZE_Y)
