extends Node3D

@export var size : float = 1 : set=change_size
@export var transition_duration : float = 0.2
var is_closing = false
var transition_step : float = 0.0 : set=set_transition_step

func start_closing():
	is_closing = true

func set_transition_step(s):
	transition_step = s
	$Cone.material_override.set_shader_parameter("transparency_cap", transition_step)

func change_size(s):
	size = s
	$Cone.scale = Vector3(s, s, s)

func _physics_process(delta):
	if is_closing:
		transition_step = max(0.0, transition_step - delta*(1.0/transition_duration))
		if transition_step == 0.0:
			queue_free()
	else:
		transition_step = min(1.0, transition_step + delta*(1.0/transition_duration))
