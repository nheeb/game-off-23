class_name PlayerAnimations extends AnimationTree

var is_attack_pending = false

@export var attacks_remaining: int = 0
@export var is_charging: bool = false
@onready var hurt_area: PlayerHurtArea = $"../PlayerHurtArea"

var combo_state = 0
var is_preparing_attack = false

func attack():
	attacks_remaining += 1

func attack_completed():
	attacks_remaining = max(attacks_remaining - 1, 0)

func should_prepare_attack():
	return is_charging

func is_attacking():
	return combo_state > 0

func no_attack_taken():
	return attacks_remaining <= 0 and not is_charging

#func _physics_process(delta):
#	print(combo_state)
