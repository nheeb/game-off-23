extends Node

var debug_visible := false

signal visibility_changed

func _process(delta):
	if Input.is_action_just_pressed("toggle_debug"):
		debug_visible = not debug_visible
		visibility_changed.emit()
		
