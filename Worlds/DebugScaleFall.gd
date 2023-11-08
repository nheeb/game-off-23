extends Node3D

var scale_timer = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_scale():
	var s = load('res://Objects/Projectiles/FallenScale.tscn').instantiate()
	$World.add_child(s)
	s.transform.origin = $World/Dragon.transform.origin
	s.transform.origin.y = 3.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale_timer -= delta
	if scale_timer <= 0:
		scale_timer = 0.5
		add_scale()
