class_name RangedAttackControls extends Node

@onready var player: CharacterBody3D = $"../.."
@onready var animation_tree: AnimationTree = $"../../animations"
@onready var movement_controls: MovementControls = $"../MovementControls"

@export var max_charge = 3.0

var is_charging = false
var charge = 0.0
var projectile_scene = preload("res://Objects/Projectiles/PlayerArrow.tscn")

func _process(delta):
	if is_charging:
		charge += delta
		charge = min(charge, max_charge)
	if is_charging and Input.is_action_just_released("shoot"):
		end_shoot()
	if Input.is_action_just_pressed("shoot"):
		start_shoot()
		
func start_shoot():
	is_charging = true
	animation_tree.set("parameters/conditions/has_released_shot", false)
	animation_tree.set("parameters/conditions/is_aiming", true)
	movement_controls.range_attack_speed_coefficient = 0.0
	charge = 0.0
	
func end_shoot():
	is_charging = false
	animation_tree.set("parameters/conditions/is_aiming", false)
	animation_tree.set("parameters/conditions/has_released_shot", true)
	movement_controls.range_attack_speed_coefficient = 1.0
	create_projectile()
	charge = 0.0
	
func create_projectile():
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.position = player.global_position
	projectile.velocity = -player.global_transform.basis.z * get_projectile_speed()
	get_tree().root.add_child(projectile)

func get_projectile_speed():
	return 8.0 + (charge * 5.0)
