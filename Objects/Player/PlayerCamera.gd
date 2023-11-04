class_name PlayerCamera extends Camera3D

@export var responsivity = 2.0
@export var player: Node3D

func _ready():
	print(global_transform.basis.z)
	print(player.global_position)
	global_position = getTargetPosition()


func _process(delta):
	global_position = lerp(global_position, getTargetPosition(), delta * responsivity)
	pass
	
func getTargetPosition():
	var camera_backwards = global_transform.basis.z
	return player.global_position + 200 * camera_backwards
