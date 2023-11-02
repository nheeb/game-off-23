extends CSGSphere3D

var speed = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.origin.x -= min(speed, max(-speed, transform.origin.x))
	transform.origin.z -= min(speed, max(-speed, transform.origin.z))
	if abs(transform.origin.x) <= speed and abs(transform.origin.z) < speed:
		queue_free()
		get_parent().base.damage(2.5)

func damage():
	var c = load('res://Objects/corpse.tscn').instantiate()
	c.transform.origin.x = transform.origin.x
	c.transform.origin.z = transform.origin.z
	get_parent().add_child(c)
	queue_free()
