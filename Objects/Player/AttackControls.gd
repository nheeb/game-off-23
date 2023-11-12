class_name AttackControls extends Node

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = $"../../animations"
@onready var player_motion: PlayerMotion = $"../PlayerMotion"
@onready var mouse_detection_layer: MouseDetectionLayer = $"../../MouseDetectionLayer"
@export var max_charge = 2.0
@export var sword_model: MeshInstance3D
@export var hurt_box: Area3D

var sword_count = 1
var is_charging = false
var is_range_charging = false
var charge = 0.0
var projectile_scene = preload("res://Objects/Projectiles/PlayerArrow.tscn")

func _process(delta):
	if player.is_dead():
		return
	if sword_count < 1:
		return
	if is_charging:
		charge += delta
		charge = min(charge, max_charge)
		if not is_range_charging and charge > 0.2:
			player_motion.range_attack_speed_coefficient = 0.5
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
	player_motion.range_attack_speed_coefficient = 1.0

func start_shoot():
	animation_tree.set("parameters/Core/conditions/performing_melee", false)
	animation_tree.set("parameters/Core/conditions/has_released_shot", false)
	animation_tree.set("parameters/Core/conditions/is_aiming", true)
	is_charging = true
	charge = 0.0
	
func perform_shoot():
	animation_tree.set("parameters/Core/conditions/is_aiming", false)
	animation_tree.set("parameters/Core/conditions/has_released_shot", true)
	create_projectile()
	reset_charge()
	sword_thrown()

func perform_melee():
	animation_tree.set("parameters/Core/conditions/is_aiming", false)
	animation_tree.set("parameters/Core/conditions/performing_melee", true)
	reset_charge()
	await get_tree().create_timer(.1).timeout
	hurt_box.monitorable = true
	player_motion.dodge_boost_speed = 8.0
	await get_tree().create_timer(.5).timeout
	hurt_box.monitorable = false
	player_motion.dodge_boost_speed = 0.0
	
func create_projectile():
	var target_position = mouse_detection_layer.get_global_layer_mouse_position()
	var distance = (target_position - player.global_position).length()
	var direction = (target_position - player.global_position).normalized()
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.source_position = player.global_position
	projectile.target_position = target_position
	var mid_point = (player.global_position + target_position) / 2.0
	var control_point_displace = distance * 0.05 * (1.5 + (charge / max_charge) * 8.0)
	projectile.control_point = mid_point + control_point_displace * player.global_transform.basis.x
	projectile.control_point_return = mid_point - control_point_displace * player.global_transform.basis.x
	projectile.path_time = distance * 0.15 * (1.0 - (charge / max_charge) * 0.5)
	get_tree().root.add_child(projectile)
	Game.main_cam.projectile_focus = projectile

func get_projectile_speed():
	return 15.0 + (charge * 15.0)
	
func sword_thrown():
	sword_count -= 1
	if sword_count < 1:
		sword_model.visible = false
	
func sword_retreived():
	sword_count += 1
	if sword_count > 0:
		sword_model.visible = true
