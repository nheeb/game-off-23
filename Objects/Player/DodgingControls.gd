class_name DodgingControls extends Node3D

@onready var player: CharacterBody3D = $"../.."
@onready var animation_tree: AnimationTree = $"../../animations"
@onready var movement_controls: MovementControls = $"../MovementControls"

@export var jump_velocity = 2.0
@export var dodge_duration = .5

var dodge_remaining_time = 0.0

func _physics_process(delta):
	if dodge_remaining_time > 0:
		dodge_remaining_time -= delta
		if dodge_remaining_time <= 0:
			stop_dodge()
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		start_dodge()
		
func start_dodge():
	dodge_remaining_time = dodge_duration
	animation_tree.set("parameters/conditions/is_dodging_completed", false)
	animation_tree.set("parameters/conditions/is_dodging", true)
	player.velocity.y = jump_velocity
	movement_controls.dodge_boost_speed = 5.0
	
func stop_dodge():
	dodge_remaining_time = 0
	animation_tree.set("parameters/conditions/is_dodging", false)
	animation_tree.set("parameters/conditions/is_dodging_completed", true)
	movement_controls.dodge_boost_speed = 0.0
	
