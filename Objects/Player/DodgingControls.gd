class_name DodgingControls extends Node3D

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = $"../../animations"
@onready var player_motion: PlayerMotion = $"../PlayerMotion"

@export var jump_velocity = 2.0
@export var dodge_duration = .5

var dodge_remaining_time = 0.0

func _physics_process(delta):
	if player.is_dead():
		return
	if PlayerStats.dodge_boost_speed <= 0:
		return
	if dodge_remaining_time > 0:
		dodge_remaining_time -= delta
		if dodge_remaining_time <= 0:
			stop_dodge()
	
	if Input.is_action_just_pressed("dodge") and player.is_on_floor():
		start_dodge()
		
func start_dodge():
	dodge_remaining_time = dodge_duration
	animation_tree.set("parameters/Core/Movement/conditions/is_dodging_completed", false)
	animation_tree.set("parameters/Core/Movement/conditions/is_dodging", true)
	player.velocity.y = jump_velocity
	player_motion.dodge_boost_speed = PlayerStats.dodge_boost_speed
	player_motion.dash_lock = true
	
func stop_dodge():
	dodge_remaining_time = 0
	animation_tree.set("parameters/Core/Movement/conditions/is_dodging", false)
	animation_tree.set("parameters/Core/Movement/conditions/is_dodging_completed", true)
	player_motion.dodge_boost_speed = 0.0
	player_motion.dash_lock = false
	
