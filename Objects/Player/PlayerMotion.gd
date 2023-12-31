class_name PlayerMotion extends Node

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = $"../../animations"
@onready var dust_track: GPUParticles3D = $"../../DustTrack"

var movement_intent: Vector3 = Vector3.ZERO

var dash_lock: bool = false
var dodge_boost_speed = 0.0
var range_attack_speed_coefficient = 1.0
var knockback_value: Vector3 = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var move_speed = 5.0
@export var turn_sensitivity = 10.0
@export var knockback_decay = 0.15

func apply_knockback(knockback: Vector3):
	knockback_value += knockback

var last_frame_global_pos : Vector3 = Vector3.ZERO
var last_frame_global_movement : Vector3

func _physics_process(delta):
	handle_movement_intent(delta)
	handle_knockback(delta)
	handle_gravity(delta)
	player.move_and_slide()
	
	dust_track.emitting = player.velocity.length_squared() > .1 and player.is_on_floor()
	last_frame_global_movement = player.global_position - last_frame_global_pos
	last_frame_global_pos = player.global_position

func get_player_intent_movement_direction():
	return movement_intent

func handle_movement_intent(delta):
	var current_movement_intent = get_player_intent_movement_direction()
	if not dash_lock && current_movement_intent.length() > 0:
		var targetRotation = player.global_transform.looking_at(player.global_position + movement_intent).basis.get_rotation_quaternion()
		player.quaternion = player.quaternion.slerp(targetRotation, turn_sensitivity * delta)
	var movement_velocity = current_movement_intent * get_movement_speed()
	movement_velocity.y = player.velocity.y
	player.velocity = movement_velocity
	
	var movement_intent_2d = Vector2(movement_intent.x, movement_intent.z)
	animation_tree.set("parameters/Core/Movement/IdleAndMovement/blend_position", movement_intent_2d)

func handle_knockback(delta):
	player.velocity += knockback_value
	knockback_value = lerp(knockback_value, Vector3.ZERO, 1.0 - pow(knockback_decay, delta))

func handle_gravity(delta):
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta

func get_movement_speed():
	return (move_speed + dodge_boost_speed) * range_attack_speed_coefficient
