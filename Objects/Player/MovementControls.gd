class_name MovementControls extends Node3D

@onready var player: Player = $"../.."
@onready var player_motion: PlayerMotion = $"../PlayerMotion"

func _physics_process(delta):
	var input_direction = Input.get_vector("movement_left", "movement_right", "movement_forwards", "movement_backwards")
	var movement_direction = Vector3(input_direction.x, 0, input_direction.y)
	if player.is_dead():
		movement_direction = Vector3.ZERO
	player_motion.movement_intent = movement_direction
