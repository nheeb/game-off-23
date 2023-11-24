extends ParallaxBackground

const movement_speed : float = 0.1

func _process(delta):
	var mouse_position := get_viewport().get_mouse_position()
	scroll_offset.x = mouse_position.x * movement_speed
	scroll_offset.y = mouse_position.y * movement_speed

