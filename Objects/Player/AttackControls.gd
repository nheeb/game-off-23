class_name AttackControls extends Node

@onready var player: Player = $"../.."
@onready var animation_tree: PlayerAnimations = $"../../animations"
@onready var player_motion: PlayerMotion = $"../PlayerMotion"
@onready var mouse_detection_layer: MouseDetectionLayer = $"../../MouseDetectionLayer"
@onready var melee_combat: MeleeCombat = $"../MeleeCombat"
@onready var eating_system: EatingSystem = $"../EatingSystem"
@export var max_charge = 2.0
@export var sword_model: Node3D

var sword_count = 1
var is_charging = false
var is_range_charging = false
var is_performing_melee = false
var charge = 0.0
var projectile_scene = preload("res://Objects/Projectiles/PlayerArrow.tscn")
var carrot_missile_scene = preload('res://Objects/Projectiles/CarrotMissile.tscn')

func _physics_process(delta):
	PlayerStats.charged_attack_type = PlayerStats.CHARGED_ATTACK.CarrotMissile
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
	if Input.is_action_just_released("melee"):
		if charge < 0.2:
			perform_melee()
		else:
			if PlayerStats.charged_attack_type == PlayerStats.CHARGED_ATTACK.None:
				perform_melee()
			elif PlayerStats.charged_attack_type == PlayerStats.CHARGED_ATTACK.Throw:
				perform_shoot()
			elif PlayerStats.charged_attack_type == PlayerStats.CHARGED_ATTACK.HeavySlash:
				if charge > 0.8:
					perform_melee_heavy()
				else:
					perform_melee()
			elif PlayerStats.charged_attack_type == PlayerStats.CHARGED_ATTACK.CarrotMissile:
				if eating_system.progress > 0:
					perform_shoot_carrot_missile()
					eating_system.use_up(1)
				else:
					perform_melee()
	if Input.is_action_just_pressed("melee"):
		start_shoot()
		
func reset_charge():
	is_charging = false
	animation_tree.is_charging = is_charging
	is_range_charging = false
	charge = 0.0
	player_motion.range_attack_speed_coefficient = 1.0

func start_shoot():
	animation_tree.set("parameters/Core/conditions/performing_melee", false)
	animation_tree.set("parameters/Core/conditions/has_released_shot", false)
	animation_tree.set("parameters/Core/conditions/is_aiming", true)
	is_charging = true
	animation_tree.is_charging = is_charging
	charge = 0.0
	
func perform_shoot():
	animation_tree.set("parameters/Core/conditions/is_aiming", false)
	animation_tree.set("parameters/Core/conditions/has_released_shot", true)
	create_projectile()
	reset_charge()
	sword_thrown()
	
func perform_shoot_carrot_missile():
	animation_tree.set("parameters/Core/conditions/is_aiming", false)
	animation_tree.set("parameters/Core/conditions/has_released_shot", true)
	create_carrot_missile()
	reset_charge()

func perform_melee():
	reset_charge()
	melee_combat.attack(1)

func perform_melee_heavy():
	reset_charge()
	melee_combat.attack(3)
	
func create_projectile():
	var target_position = mouse_detection_layer.get_global_layer_mouse_position()
	var distance = (target_position - player.global_position).length()
	var direction = (target_position - player.global_position).normalized()
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.source_position = player.global_position
	projectile.target_position = target_position
	var mid_point = (player.global_position + target_position) / 2.0
	var control_point_displace = distance * 0.05
	projectile.control_point = mid_point + control_point_displace * player.global_transform.basis.x
	projectile.control_point_return = mid_point - control_point_displace * player.global_transform.basis.x
	projectile.path_time = distance * 0.09 * (1.0 - (charge / max_charge) * 0.5)
	get_tree().root.add_child(projectile)
	Game.main_cam.projectile_focus = projectile
	
func create_carrot_missile():
	var target_position = mouse_detection_layer.get_global_layer_mouse_position()
	var missile: CarrotMissile = carrot_missile_scene.instantiate()
	missile.position = player.global_position
	get_tree().root.add_child(missile)
	missile.look_at(target_position)

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
