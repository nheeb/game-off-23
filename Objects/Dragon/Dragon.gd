class_name Dragon extends Node3D

var hp: int
var stage := 1

# Signals
signal turn_done

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
enum TurnType {NO_TURN, FOLLOW, TURN, WITH_MOVEMENT}

var movement_type: MovementType
var movement_target_position: Vector3
var movement_pivot_position: Vector3
var movement_speed: float
var turn_type: TurnType
var body_direction_target_node: Node3D
var body_direction_target_position: Vector3
var angular_speed: float
var head_direction_target: Node3D

# Constanst
const DEFAULT_MOVEMENT_SPEED = 4.0
const DEFAULT_ANGULAR_SPEED = 0.7
const MOVEMENT_TARGET_RANGE = 1.5

func _ready():
	Game.dragon = self
	DebugInfo.visibility_changed.connect(func (): $DebugStateLabel.visible = not $DebugStateLabel.visible)

func _physics_process(delta):
	statemachine_process(delta)
	movement_process(delta)
	turning_process(delta)

func statemachine_process(delta: float):
	if new_state != "":
		current_state = new_state
		new_state = ""
		current_state_object = get_node("States/" + current_state)
		var index = current_state_object.set_active()
		current_state_object.effect_start(index)
	if current_state != null:
		current_state_object.effect_process(delta)
		if new_state == "":
			new_state = current_state_object.get_next_state()
			if new_state != "":
				pass
				print("Next state: " + new_state)

func force_state_change(_new_state: String):
	new_state = _new_state

func reset_behaviour():
	movement_type = MovementType.STANDING
	turn_type = TurnType.NO_TURN
	movement_speed = DEFAULT_MOVEMENT_SPEED
	angular_speed = DEFAULT_ANGULAR_SPEED
	movement_target_position = Vector3.ZERO
	body_direction_target_position = Vector3.ZERO
	body_direction_target_node = null
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

var last_movement_vector : Vector3
func movement_process(delta: float):
	var old_pos := global_position
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
		MovementType.STANDING:
			return
	$CollisionBody.velocity = move_vector
	$CollisionBody.move_and_slide()
	
	global_position = $CollisionBody.global_position
	$CollisionBody.position = Vector3.ZERO
	
	last_movement_vector = global_position - old_pos

func turning_process(delta: float):
	if turn_type == TurnType.NO_TURN and movement_type == MovementType.DIRECTIONAL:
		turn_type = TurnType.WITH_MOVEMENT
	var clean_current_direction: Vector3 = Functions.no_y_normalized(to_global(Vector3.FORWARD))
	var target_direction: Vector3
	var turning_success := false
	match turn_type:
		TurnType.TURN:
			target_direction = Functions.no_y_normalized(body_direction_target_position - global_position)
			print( "!")
			print(clean_current_direction)
			print(target_direction)
		TurnType.FOLLOW:
			target_direction = Functions.no_y_normalized(body_direction_target_node.global_position - global_position)
		TurnType.WITH_MOVEMENT:
			target_direction = Functions.no_y_normalized(last_movement_vector)
		TurnType.NO_TURN:
			return
	var angle_diff := clean_current_direction.signed_angle_to(target_direction, Vector3.UP)
	var angle_dist : float = angular_speed * delta * sign(angle_diff)
	print(angle_diff)
	print(angle_dist)
	if abs(angle_dist) > abs(angle_diff):
		angle_dist = angle_diff
		turning_success = true
	self.rotate(Vector3.UP, angle_dist)
	if turning_success:
		emit_signal("turn_done")

func get_nearest_collision(direction: Vector3) -> Vector3:
	%PlayerRay.target_position = direction.normalized() * 1000.0
	return %PlayerRay.get_collision_point()
