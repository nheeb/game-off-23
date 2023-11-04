extends Spatial
class_name MouseDetectionLayer

var current_mouse_position: Vector3
var position_has_been_calculated_this_frame := false

func get_plane() -> Plane:
	return Plane($Origin.global_transform.origin, $xDirection.global_transform.origin, $zDirection.global_transform.origin)

func get_global_layer_mouse_position() -> Vector3:
	if not position_has_been_calculated_this_frame:
		current_mouse_position = calculate_mouse_position()
		position_has_been_calculated_this_frame = true
	return current_mouse_position

func calculate_mouse_position() -> Vector3:
	var camera = GameInfo.main_cam
	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = camera.project_ray_normal(get_viewport().get_mouse_position())
	return get_plane().intersects_ray(from, to)

export var layer_name := "TEST"
func _ready():
	GameInfo.mouse_layers[layer_name] = self

func _physics_process(delta):
	position_has_been_calculated_this_frame = false
