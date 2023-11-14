class_name JumpControls extends Node

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = $"../../animations"
@onready var player_motion: PlayerMotion = $"../PlayerMotion"

@export var jump_velocity = 8.0
@export var forward_boost_velocity = 1.0

var is_jumping = false

func _physics_process(delta):
	if player.is_dead():
		return
	if is_jumping and player.is_on_floor():
		stop_jump()
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		start_jump()
		
func start_jump():
	is_jumping = true
	animation_tree.set("parameters/Core/conditions/is_jumping_completed", false)
	animation_tree.set("parameters/Core/conditions/is_jumping", true)
	player.velocity.y = jump_velocity
	player_motion.dodge_boost_speed = forward_boost_velocity
	
func stop_jump():
	is_jumping = false
	animation_tree.set("parameters/Core/conditions/is_jumping", false)
	animation_tree.set("parameters/Core/conditions/is_jumping_completed", true)
	player_motion.dodge_boost_speed = 0.0
	
