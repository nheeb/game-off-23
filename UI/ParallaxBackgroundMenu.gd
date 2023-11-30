extends ParallaxBackground

const movement_speed : float = 0.1

func _process(delta):
	var mouse_position := get_viewport().get_mouse_position()
	var viewport_size = get_viewport().size
	var vector : Vector2
	vector = Vector2(viewport_size) - mouse_position
	
	if (mouse_position.x < 0):
		return
	elif (mouse_position.x > viewport_size.x):
		return

	if (mouse_position.y < 0):
		return
	elif (mouse_position.y > viewport_size.y):
		return
	
	
	scroll_offset.x = vector.x * movement_speed
	scroll_offset.y = vector.y * movement_speed

