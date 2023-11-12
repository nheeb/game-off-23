class_name MovementControls extends Node3D

@onready var player: Player = $"../.."
@onready var player_motion: PlayerMotion = $"../PlayerMotion"

func _physics_process(delta):
	var input_direction = Input.get_vector("movement_left", "movement_right", "movement_forwards", "movement_backwards")
	var movement_direction = Vector3(input_direction.x, 0, input_direction.y)
	if player.is_dead():
		movement_direction = Vector3.ZERO
	if Game.main_cam:
		var angles = Game.main_cam.basis.get_euler()
		var control_basis = Basis(Vector3.UP, angles.y)
		movement_direction = control_basis * movement_direction
	movement_direction.y = 0
	player_motion.movement_intent = movement_direction
