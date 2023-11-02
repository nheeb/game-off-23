extends CSGBox3D

var hp = 100
var depth = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func damage(amount):
	transform.origin.y -= amount/hp*depth
	if transform.origin.y <= -depth/2:
		print("you lose")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
