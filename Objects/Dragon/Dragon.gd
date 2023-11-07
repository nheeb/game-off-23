class_name Dragon extends Node3D

var hp: int
var stage := 1

# Areas & Positions
@onready var bite_area : PlayerDamageArea = %BiteArea
@onready var tail_area : PlayerDamageArea = %TailArea
@onready var head_position : Node3D = %HeadPosition

# State Machine
var current_state := "":
	set(value):
		current_state = value
		%DebugStateLabel.text = value
var new_state := "Idle"
var current_state_object: Node

# Battlefield analysis
var player_in_sight : bool
var player_distance : float
var player_direction_clean: Vector3
var player_face_angle: float

# Behaviour
enum MovementType {STANDING, DIRECTIONAL, CURVED_CLOCKWISE, CURVED_COUNTERCLOCKWISE}

var movement_type: MovementType
var movement_target_position: Vector3
var movement_pivot_position: Vector3
var movement_speed: float
var body_direction_target: Node3D
var angular_speed: float
var head_direction_target: Node3D

# Constanst
const DEFAULT_MOVEMENT_SPEED = 1.0
const DEFAULT_ANGULAR_SPEED = 1.0
const MOVEMENT_TARGET_RANGE = 1.5

func _ready():
	Game.dragon = self
	DebugInfo.visibility_changed.connect(func (): $DebugStateLabel.visible = not $DebugStateLabel.visible)

func _physics_process(delta):
	if new_state != "":
		current_state = new_state
		new_state = ""
		current_state_object = get_node("States/" + current_state)
		current_state_object.effect_start()
	if current_state != null:
		current_state_object.effect_process(delta)
		if new_state == "":
			new_state = current_state_object.get_next_state()
	
	movement_process(delta)
	turning_process(delta)

func force_state_change(_new_state: String):
	new_state = _new_state

func reset_behaviour():
	movement_type = MovementType.STANDING
	movement_speed = DEFAULT_MOVEMENT_SPEED
	angular_speed = DEFAULT_ANGULAR_SPEED
	movement_target_position = Vector3.ZERO
	body_direction_target = null
	head_direction_target = null

func analyse_battlefield():
	%PlayerRay.target_position = to_local(Game.player.global_position)
	player_in_sight = not %PlayerRay.is_colliding()
	player_distance = global_position.distance_to(Game.player.global_position)
	player_direction_clean = global_position.direction_to(Game.player.global_position)
	player_direction_clean.y = 0.0
	player_direction_clean = player_direction_clean.normalized()
	player_face_angle = rad_to_deg(player_direction_clean.angle_to(to_global(Vector3.FORWARD)))

func choose_action():
	var running_total := 0.0
	var cumulative_chances := []
	var state_names := []
	for state in $States.get_children():
		if state.has_method("get_probability"):
			var prob = state.get_probability()
			if prob != 0.0:
				running_total += prob
				cumulative_chances.append(running_total)
				state_names.append(state.name)
	var random_choice := randf() * running_total
	for i in range(len(cumulative_chances)):
		if random_choice <= cumulative_chances[i]:
			new_state = state_names[i]
			break

func movement_process(delta: float):
	var move_vector := Vector3.ZERO
	match movement_type:
		MovementType.DIRECTIONAL:
			var clean_distance = Functions.remove_y_value(global_position).distance_to(Functions.remove_y_value(movement_target_position))
			if clean_distance <= MOVEMENT_TARGET_RANGE:
				movement_type = MovementType.STANDING
			var clean_direction := global_position.direction_to(movement_target_position)
			clean_direction.y = 0.0
			move_vector = clean_direction.normalized() * movement_speed
		MovementType.CURVED_CLOCKWISE:
			move_vector = global_position.direction_to(movement_pivot_position).cross(Vector3.UP).normalized() * movement_speed
		MovementType.CURVED_COUNTERCLOCKWISE:
			move_vector = global_position.direction_to(movement_pivot_position).cross(Vector3.UP).normalized() * movement_speed
	
	$CollisionBody.velocity = move_vector
	$CollisionBody.move_and_slide()
	
	global_position = $CollisionBody.global_position
	$CollisionBody.position = Vector3.ZERO

func turning_process(delta: float):
	pass

func get_nearest_collision(direction: Vector3) -> Vector3:
	%PlayerRay.target_position = direction.normalized() * 1000.0
	return %PlayerRay.get_collision_point()
