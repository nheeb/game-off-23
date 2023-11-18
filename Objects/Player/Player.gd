class_name Player extends CharacterBody3D

@onready var animation_tree: AnimationTree = $animations

func is_dead():
	return animation_tree.get("parameters/conditions/is_dead")

func _ready():
	Game.player = self
	Game.player_health_system = get_health_system()
	Functions.recursive_set_light_layers(self, 3)

func get_attack_controls() -> AttackControls:
	return %AttackControls

func get_health_system() -> HealthSystem:
	return %HealthSystem

func get_motion() -> PlayerMotion:
	return %PlayerMotion
