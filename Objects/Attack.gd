extends CSGCylinder3D

var range = 5
var expansion_speed = 20
var s = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	s += delta * expansion_speed
	scale.x = s
	scale.z = s
	if s > range:
		queue_free()
