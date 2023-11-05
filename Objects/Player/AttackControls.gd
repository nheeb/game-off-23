class_name AttackControls extends Node

@onready var player: CharacterBody3D = $"../.."
@onready var animation_tree: AnimationTree = $"../../animations"
@onready var movement_controls: MovementControls = $"../MovementControls"
@onready var mouse_detection_layer: MouseDetectionLayer = $"../../MouseDetectionLayer"
@export var max_charge = 3.0

var is_charging = false
var is_range_charging = false
var charge = 0.0
var projectile_scene = preload("res://Objects/Projectiles/PlayerArrow.tscn")

func _process(delta):
	if is_charging:
		charge += delta
		charge = min(charge, max_charge)
		if not is_range_charging and charge > 0.2:
			movement_controls.range_attack_speed_coefficient = 0.0
			is_range_charging = true
	if is_charging and Input.is_action_just_released("melee"):
		if charge < 0.2:
			perform_melee()
		else:
			perform_shoot()
	if Input.is_action_just_pressed("melee"):
		start_shoot()
		
func reset_charge():
	is_charging = false
	is_range_charging = false
	charge = 0.0
	movement_controls.range_attack_speed_coefficient = 1.0

func start_shoot():
	animation_tree.set("parameters/conditions/performing_melee", false)
	animation_tree.set("parameters/conditions/has_released_shot", false)
	animation_tree.set("parameters/conditions/is_aiming", true)
	is_charging = true
	charge = 0.0
	
func perform_shoot():
	animation_tree.set("parameters/conditions/is_aiming", false)
	animation_tree.set("parameters/conditions/has_released_shot", true)
	create_projectile()
	reset_charge()

func perform_melee():
	animation_tree.set("parameters/conditions/is_aiming", false)
	animation_tree.set("parameters/conditions/performing_melee", true)
	reset_charge()
	
func create_projectile():
	var target_position = mouse_detection_layer.get_global_layer_mouse_position()
	var direction = (target_position - player.global_position).normalized()
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.position = player.global_position
	projectile.velocity = direction * get_projectile_speed()
	get_tree().root.add_child(projectile)

func get_projectile_speed():
	return 8.0 + (charge * 5.0)
