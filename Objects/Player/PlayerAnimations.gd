class_name PlayerAnimations extends AnimationTree

var is_attack_pending = false

@export var attacks_remaining: int = 0
@export var is_charging: bool = false
@onready var hurt_area: PlayerHurtArea = $"../PlayerHurtArea"
@onready var activate_attack_timer: Timer = $"./ActivateAttackTimer"
@onready var deactivate_attack_timer: Timer = $"./DeactivateAttackTimer"

func _ready():
	connect('animation_started', _on_animation_started)
	connect('animation_finished', _on_animation_finished)
	activate_attack_timer.timeout.connect(_on_attack_activate)
	deactivate_attack_timer.timeout.connect(_on_attack_deactivate)

func _on_animation_started(animation_name: String):
	if is_attack_pending:
		return
	if "2H_Melee" in animation_name:
		is_attack_pending = true
		activate_attack_timer.wait_time = 0.5
		activate_attack_timer.start()
		attack_completed()

func _on_animation_finished(animation_name: String):
	if "2H_Melee" in animation_name:
		hurt_area.set_attacking(false)
		activate_attack_timer.stop()
		deactivate_attack_timer.stop()
		is_attack_pending = false

func attack():
	attacks_remaining += 1

func attack_completed():
	attacks_remaining = max(attacks_remaining - 1, 0)

func should_prepare_attack():
	return attacks_remaining > 0 or is_charging

func no_attack_taken():
	return attacks_remaining <= 0 and not is_charging
	
func _on_attack_activate():
	hurt_area.set_attacking(true)
	activate_attack_timer.stop()
	deactivate_attack_timer.wait_time = 0.05
	deactivate_attack_timer.start()
	
func _on_attack_deactivate():
	hurt_area.set_attacking(false)
	deactivate_attack_timer.stop()
