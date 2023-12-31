extends Node3D

@export var size : float = 1 : set=change_size
@export var transition_duration : float = 1.2
var is_closing = false
var transition_step : float = 0.0 : set=set_transition_step

func _ready():
	self.material_override.set_shader_parameter("progress", 0.0)

func set_transition_step(s):
	transition_step = s
	self.material_override.set_shader_parameter("progress", transition_step)

func change_size(s):
	size = s
	scale = Vector3(s, s, s)

func _physics_process(delta):
	if is_closing:
		transition_step = max(0.0, transition_step - delta*(1.0/transition_duration))
	else:
		transition_step = min(1.0, transition_step + delta*(1.0/transition_duration))
