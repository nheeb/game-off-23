extends Node3D

signal hint_can_fade

const FLASH_DURATION = .5

func _ready():
	$MeshInstance3D.material_override.set("shader_parameter/progress", 0.0)
	$MeshInstance3D.visible = true
	var tween := get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($MeshInstance3D.material_override, "shader_parameter/progress", 1.0, FLASH_DURATION)
	tween.tween_method(set_collision_polygon_end, 0.2, 1.0, FLASH_DURATION - .1)
	tween.chain().tween_interval(0.7)
	tween.chain().tween_callback(queue_free)
	await get_tree().create_timer(.2).timeout
	hint_can_fade.emit()

const SIZE_X = 4.0
const SIZE_Y = 16.0
func set_collision_polygon_end(progress: float):
	var polygon = $PlayerDamageArea/CollisionPolygon3D.polygon
	polygon[1] = progress * Vector2(SIZE_X, SIZE_Y)
	polygon[2] = progress * Vector2(-SIZE_X, SIZE_Y)
	$PlayerDamageArea/CollisionPolygon3D.polygon = polygon
