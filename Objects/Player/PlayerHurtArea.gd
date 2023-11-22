class_name PlayerHurtArea extends Area3D

var attack_state: bool = false

func set_attacking(value: bool):
	attack_state = value

func is_attacking():
	return attack_state

func _physics_process(delta):
	DebugInfo.refresh_info("Attacking: ", str(attack_state))
