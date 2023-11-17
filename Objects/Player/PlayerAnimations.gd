class_name PlayerAnimations extends AnimationTree

var attacks_remaining: int = 0
var is_charging: bool = false

func _ready():
	print('connect')
	connect('animation_started', _on_animation_started)

var i = false
func _on_animation_started(animation_name: String):
	# Function invoking twice bug workaround
	if not i:
		i = true
		return
	i = false
	
	if animation_name == '2H_Melee_Attack_Spin':
		attacks_remaining -= 1

func attack():
	attacks_remaining += 1
	print(attacks_remaining)
	
func attack_completed():
	attacks_remaining -= 1

func should_prepare_attack():
	return attacks_remaining > 0 or is_charging
