extends Node3D

@onready var player: CharacterBody3D = $"../.."

@export var move_speed = 5.0
@export var jump_velocity = 10.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	handle_movement_intent()
	handle_gravity(delta)
	handle_jumping()
	player.move_and_slide()

func handle_movement_intent():
	var input_direction = Input.get_vector("movement_left", "movement_right", "movement_forwards", "movement_backwards")
	var movement_velocity = Vector3(input_direction.x, 0, input_direction.y) * move_speed
	movement_velocity.y = player.velocity.y
	player.velocity = movement_velocity

func handle_gravity(delta):
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta

func handle_jumping():
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = jump_velocity
