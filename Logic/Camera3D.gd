extends Camera3D

var speed = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var forward_velocity = Vector3(sin(deg_to_rad(45)),0, cos(deg_to_rad(45))) * speed
	var sideway_velocity = Vector3(sin(deg_to_rad(45+90)),0, cos(deg_to_rad(45+90))) * speed
	
	if Input.is_key_pressed(KEY_W):
		transform.origin -= forward_velocity
	if Input.is_key_pressed(KEY_S):
		transform.origin += forward_velocity
	if Input.is_key_pressed(KEY_A):
		transform.origin -= sideway_velocity
	if Input.is_key_pressed(KEY_D):
		transform.origin += sideway_velocity
