class_name PlayerAnimations extends AnimationTree

@export var hurt_box: Area3D

var attacks_remaining: int = 0
var is_charging: bool = false

func _ready():
	connect('animation_started', _on_animation_started)

var i = false
func _on_animation_started(animation_name: String):
	# Function invoking twice bug workaround
	if not i:
		i = true
		return
	i = false
	
	print(animation_name)
	
	if animation_name == 'knight_animations/2H_Melee_Attack_Spin':
		hurt_box.monitorable = true
		attacks_remaining -= 1
	else:
		hurt_box.monitorable = false

func attack():
	attacks_remaining += 1
	
func attack_completed():
	attacks_remaining -= 1

func should_prepare_attack():
	return attacks_remaining > 0 or is_charging
