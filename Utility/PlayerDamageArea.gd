class_name PlayerDamageArea extends Area3D

@export var damage := 0
@export var knockback_force := 0.0
@export var active := false
@export var perishable := true
@export var lifetime := 0.0
@export var default_lifetime := .3
@export var delete_on_perish := false
@export var delete_on_player_hit := false

@onready var knockback_origin : Node3D = $KnockbackOrigin

func _physics_process(delta):
	if active:
		if perishable:
			lifetime -= delta
			if lifetime <= 0.0:
				active = false
				if delete_on_perish:
					queue_free()

func _on_area_entered(area):
	if active:
		do_damage()
		if delete_on_player_hit:
			queue_free()

func activate():
	active = true
	if perishable:
		lifetime = default_lifetime

func do_damage():
	pass
