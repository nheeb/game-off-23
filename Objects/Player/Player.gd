class_name Player extends CharacterBody3D

@onready var animation_tree: AnimationTree = $animations

func is_dead():
	return animation_tree.get("parameters/conditions/is_dead") or Game.current_game_state == Game.GAME_STATE.Cutscene

func _ready():
	Game.player = self
	Game.player_health_system = get_health_system()
	Functions.recursive_set_light_layers(self, 3)

func get_attack_controls() -> AttackControls:
	return %AttackControls

func get_health_system() -> HealthSystem:
	return %HealthSystem

func get_eating_system() -> EatingSystem:
	return %EatingSystem

func get_motion() -> PlayerMotion:
	return %PlayerMotion

func get_magic_casting() -> MagicCasting:
	return %MagicCasting
	
func get_after_hit_system() -> AfterHitSystem:
	return %AfterHitSystem

@export var sound_attack : Array
@export var sound_hurt : Array
@export var sound_dash : Array
@export var sound_death : Array

enum SoundType {Attack,Hurt,Dash,Death}

func play_sound(type:SoundType) -> void:
	match(type):
		SoundType.Attack:
			await get_tree().create_timer(0.1).timeout
			%AudioPlayerAttack.stream = sound_attack.pick_random()
			%AudioPlayerAttack.play()
			return
		SoundType.Hurt:
			%AudioPlayerHurt.stream = sound_hurt.pick_random()
			%AudioPlayerHurt.play()
			return
		SoundType.Dash:
			%AudioPlayerDash.stream = sound_dash.pick_random()
			%AudioPlayerDash.play()
			return
		SoundType.Death:
			%AudioPlayerDeath.stream = sound_death.pick_random()
			%AudioPlayerDeath.play()
			return
	
