class_name Player extends CharacterBody3D

@onready var animation_tree: AnimationTree = $animations

func is_dead():
	return animation_tree.get("parameters/conditions/is_dead")
