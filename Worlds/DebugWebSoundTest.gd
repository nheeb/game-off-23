extends Node3D
@export var sound_source : int = 64

# Called when the node enters the scene tree for the first time.
func _ready():
	var f = load('res://Objects/Effects/Fire.tscn')
	var r = int(floor(sqrt(sound_source)))
	for i in range(sound_source):
		var fi = f.instantiate()
		fi.transform.origin.x += (i % r) * 2
		fi.transform.origin.z += floor(i / r) * 2
		$SoundProducers.add_child(fi)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
