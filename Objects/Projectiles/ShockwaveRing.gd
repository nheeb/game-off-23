@tool extends MeshInstance3D

@export var state: float = 0.01 : set = _set_state, get = _get_state

func _set_state(new_state: float):
	state = new_state
	print('set')
	var torus: TorusMesh = mesh as TorusMesh
	torus.inner_radius = new_state
	torus.outer_radius = new_state + 1.1
	
func _get_state():
	return state

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
