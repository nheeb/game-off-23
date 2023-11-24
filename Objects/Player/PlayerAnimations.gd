class_name PlayerAnimations extends AnimationTree

@export var attacks_remaining: int = 0
@export var is_charging: bool = false
@onready var hurt_area: PlayerHurtArea = $"../PlayerHurtArea"

func _ready():
	connect('animation_started', _on_animation_started)
	connect('animation_finished', _on_animation_finished)

var i = false
func _on_animation_started(animation_name: String):
	# Function invoking twice bug workaround
	if not i:
		i = true
		return
	i = false
	if "2H_Melee" in animation_name:
		hurt_area.set_attacking(true)
		attack_completed()

func _on_animation_finished(animation_name: String):
	if "2H_Melee" in animation_name:
		hurt_area.set_attacking(false)

func attack():
	attacks_remaining += 1

func attack_completed():
	attacks_remaining = max(attacks_remaining - 1, 0)

func should_prepare_attack():
	return attacks_remaining > 0 or is_charging

func no_attack_taken():
	return attacks_remaining <= 0 and not is_charging
