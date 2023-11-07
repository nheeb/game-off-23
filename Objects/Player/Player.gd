class_name Player extends CharacterBody3D

@onready var animation_tree: AnimationTree = $animations

func is_dead():
	return animation_tree.get("parameters/conditions/is_dead")

func _ready():
	Game.player = self
	Game.player_health_system = get_health_system()

func get_attack_controls() -> AttackControls:
	return %AttackControls

func get_health_system() -> HealthSystem:
	return %HealthSystem
