extends Node

@onready var magic_casting: MagicCasting = $"../MagicCasting"

func _physics_process(delta):
	if Input.is_action_just_pressed("cast"):
		magic_casting.cast()
