class_name MeleeCombat extends Node

@onready var preparing_phase_timer: Timer = $"./PreparingPhaseTimer"
@onready var damaging_phase_timer: Timer = $"./DamagingPhaseTimer"
@onready var completing_phase_timer: Timer = $"./CompletingPhaseTimer"
@onready var hurt_area: PlayerHurtArea = $"../../PlayerHurtArea"
@onready var animations: PlayerAnimations = $"../../animations"

enum ATTACK_STATE {None, Preparing, Damaging, Completing }
var attack_state = ATTACK_STATE.None
var combo_state = 0
var additional_attack_pending = false
var current_damage: int = 0
	
func attack(damage: int):
	current_damage = damage
	if attack_state == ATTACK_STATE.None:
		print('start attack '+str(combo_state))
		_start_attack()
	elif combo_state < 3:
		print('already attacking '+str(combo_state))
		additional_attack_pending = true

func _update_animation_state():
	animations.is_preparing_attack = attack_state == ATTACK_STATE.Preparing
	animations.combo_state = combo_state

func _start_attack():
	Game.player.call_deferred('play_sound', Game.player.SoundType.Attack)
	print('preparing '+str(combo_state))
	attack_state = ATTACK_STATE.Preparing
	combo_state += 1
	_update_animation_state()
	preparing_phase_timer.wait_time = 0.3
	preparing_phase_timer.start()

func _on_preparing_state_finished():
	preparing_phase_timer.stop()
	
	print('damaging')
	attack_state = ATTACK_STATE.Damaging
	hurt_area.set_attacking(true, current_damage)
	current_damage = 0
	damaging_phase_timer.wait_time = 0.05
	damaging_phase_timer.start()
	
func _on_damaging_state_finished():
	damaging_phase_timer.stop()
	
	print('completing')
	attack_state = ATTACK_STATE.Completing
	hurt_area.set_attacking(false)
	completing_phase_timer.wait_time = 0.4
	completing_phase_timer.start()
	
func _on_completing_state_finished():
	completing_phase_timer.stop()
	
	print('none')
	attack_state = ATTACK_STATE.None
	if additional_attack_pending:
		additional_attack_pending = false
		_start_attack()
	else:
		combo_state = 0
	_update_animation_state()
