class_name MovementControls extends Node3D

@onready var player: CharacterBody3D = $"../.."
@onready var animation_tree: AnimationTree = $"../../animations"

@export var move_speed = 5.0
@export var turn_sensitivity = 10.0

var dodge_boost_speed = 0.0
var range_attack_speed_coefficient = 1.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	handle_movement_intent(delta)
	handle_gravity(delta)
	player.move_and_slide()

func handle_movement_intent(delta):
	var input_direction = Input.get_vector("movement_left", "movement_right", "movement_forwards", "movement_backwards")
	var movement_velocity = Vector3(input_direction.x, 0, input_direction.y)
	if movement_velocity.length() > 0:
		var targetRotation = player.global_transform.looking_at(player.global_position + movement_velocity).basis.get_rotation_quaternion()
		player.quaternion = player.quaternion.slerp(targetRotation, turn_sensitivity * delta)
	movement_velocity *= get_movement_speed()
	movement_velocity.y = player.velocity.y
	player.velocity = movement_velocity
	
	animation_tree.set("parameters/IdleAndMovement/blend_position", input_direction)
	animation_tree.set("parameters/Dodge/blend_position", input_direction)
	
func handle_gravity(delta):
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta

func get_movement_speed():
	return (move_speed + dodge_boost_speed) * range_attack_speed_coefficient
