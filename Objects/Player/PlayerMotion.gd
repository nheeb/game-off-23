class_name PlayerMotion extends Node

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = $"../../animations"

var movement_intent: Vector3 = Vector3.ZERO

var dodge_boost_speed = 0.0
var range_attack_speed_coefficient = 1.0
var knockback_value: Vector3 = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var move_speed = 5.0
@export var turn_sensitivity = 10.0
@export var knockback_decay = 3.0

func apply_knockback(knockback: Vector3):
	knockback_value += knockback

func _physics_process(delta):
	handle_movement_intent(delta)
	handle_knockback(delta)
	handle_gravity(delta)
	player.move_and_slide()

func handle_movement_intent(delta):
	if movement_intent.length() > 0:
		var targetRotation = player.global_transform.looking_at(player.global_position + movement_intent).basis.get_rotation_quaternion()
		player.quaternion = player.quaternion.slerp(targetRotation, turn_sensitivity * delta)
	var movement_velocity = movement_intent * get_movement_speed()
	movement_velocity.y = player.velocity.y
	player.velocity = movement_velocity
	
	animation_tree.set("parameters/Core/IdleAndMovement/blend_position", movement_intent)
	animation_tree.set("parameters/Core/Dodge/blend_position", movement_intent)

func handle_knockback(delta):
	player.velocity += knockback_value
	knockback_value = lerp(knockback_value, Vector3.ZERO, knockback_decay * delta)

func handle_gravity(delta):
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta

func get_movement_speed():
	return (move_speed + dodge_boost_speed) * range_attack_speed_coefficient
