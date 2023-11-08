extends Node

var debug_visible := false

signal visibility_changed

const DEBUG_INFO_ENTRY = preload("res://Utility/DebugInfoEntry.tscn")

func _process(delta):
	if Input.is_action_just_pressed("toggle_debug"):
		debug_visible = not debug_visible
		visibility_changed.emit()
		$CanvasLayer.visible = debug_visible

func refresh_info(_name, _value):
	_value = str(_value)
	for entry in $CanvasLayer/Control/VBoxContainer.get_children():
		if entry.info_name == _name:
			entry.set_info(_name, _value)
			return
	var new_entry = DEBUG_INFO_ENTRY.instantiate()
	$CanvasLayer/Control/VBoxContainer.add_child(new_entry)
	new_entry.set_info(_name, _value)
