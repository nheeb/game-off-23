extends DragonState

func get_probability() -> float:
	if dragon.player_distance <= 5.8 and dragon.player_face_angle > 100.0:
		return .35
	else:
		return 0.0

func effect_start(index):
	dragon.angular_speed *= .33
	var turn_sign = sign(dragon.player_face_angle_signed_rad)
	dragon.turn_type = Dragon.TurnType.SPIN
	dragon.body_direction_target_direction = (-dragon.global_transform.basis.z).rotated(Vector3.UP, -turn_sign * deg_to_rad(30.0))
	await dragon.turn_done
	dragon.angular_speed *= 9.0
	dragon.body_area.activate()
	dragon.body_direction_target_direction = (-dragon.global_transform.basis.z).rotated(Vector3.UP, turn_sign * deg_to_rad(40.0))
	await dragon.turn_done
	dragon.body_direction_target_direction = (-dragon.global_transform.basis.z).rotated(Vector3.UP, turn_sign * deg_to_rad(170.0))
	await dragon.turn_done
	await get_tree().create_timer(.3).timeout
	next_state = "Idle"

func effect_process(delta):
	pass


