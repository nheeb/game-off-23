class_name PlayerHurtArea extends Area3D

@export var attack_state: bool = false
var damage: int = 1

func set_attacking(value: bool, _damage: int = 0):
	attack_state = value
	self.damage = _damage 

func is_attacking():
	return attack_state

func _physics_process(delta):
	DebugInfo.refresh_info("Attacking: ", str(attack_state))
