class_name Dragon extends Node3D

# Dragon Stats
var stage := 1
var is_flying := false
var hp : int
var invincible := false

# Signals
signal turn_done
signal movement_done
signal stage_defeated
signal victory

# Sounds
@export var sound_dragon_damage : Array
@export var sound_scale_drop : Array
@export var sound_dragon_wing : Array

# Areas & Positions
@onready var bite_area : PlayerDamageArea = %BiteArea
@onready var tail_area : PlayerDamageArea = %TailArea
@onready var body_area : PlayerDamageArea = %BodyArea
@onready var air_knockback_area : PlayerDamageArea = %AirKnockbackArea
@onready var jump_landing_area : PlayerDamageArea = %JumpLandingArea
@onready var head_position : Node3D = %HeadPosition
@onready var head_position_2 : Node3D = %HeadPosition2
@onready var tail_position : Node3D = %TailPosition
@onready var model : Node3D = %Model
@onready var animations : DragonAnimations = $AnimationTree

# State Machine
var states : Array[DragonState]# = ($States.get_children().filter(func (x): return x is DragonState)) as Array[DragonState]
var current_state := "":
	set(value):
		current_state = value
		%DebugStateLabel.text = value
		DebugInfo.refresh_info("Current Dragon State: ", value)
var new_state := "Idle"
var current_state_object: DragonState
var state_history := [""]
var first_idle_state := true

# Battlefield analysis
var player_in_sight : bool
var player_distance : float
var player_direction_clean: Vector3
var player_face_angle: float
var player_face_angle_signed_rad: float
var player_dist_arena: float

# Behaviour
enum MovementType {STANDING, DIRECTIONAL, CURVED_CLOCKWISE, CURVED_COUNTERCLOCKWISE}
enum TurnType {NO_TURN, FOLLOW, TURN, WITH_MOVEMENT, SPIN}

var movement_type: MovementType
var movement_target_position: Vector3
var movement_pivot_position: Vector3
var movement_speed: float
var turn_type: TurnType
var body_direction_target_node: Node3D
var body_direction_target_position: Vector3
var body_direction_target_direction: Vector3
var angular_speed: float
var head_direction_target: Node3D
var has_gravity := true

# Fly Wave Animation
var fly_wave_tween: Tween
@export var fly_wave_curve: Curve
@export var fly_wave_height := .7
@export var fly_wave_duration := .95
@onready var fly_wave_pivot: Node3D = %FlyWavePivot

# Scales & Colors
var scale_areas : Array[DragonScaleArea] = []
var scale_meshes : Array[MeshInstance3D] = []
@onready var colors: DragonColors = %DragonColors

# Constanst
const DEFAULT_MOVEMENT_SPEED = 4.6
const DEFAULT_ANGULAR_SPEED = 1.55
const GRAVITY = 3.5
const MOVEMENT_TARGET_RANGE = 2.5
const FLY_HEIGHT = 3.5

func _ready():
	Game.dragon = self
	Game.main_cam.boss_focus = self
	$DebugStateLabel.visible = DebugInfo.debug_visible
	fly_wave_curve.bake()
	DebugInfo.visibility_changed.connect(func (): $DebugStateLabel.visible = not $DebugStateLabel.visible)
	states = []
	states.append_array($States.get_children().filter(func (x): return x is DragonState))
	connect_scales()
	for area in $DamageAreas.get_children():
		area.visible = true
	colors.make_everything_ready()

func revive_hp():
	for scale_area in scale_areas:
		scale_area.reset_hp()
	refresh_hp()

func refresh_hp():
	hp = scale_areas.reduce(func (x,y): return x+y.hp, 0)
	PlayerUI.dragon_health_bar.health = hp
	if hp <= 0:
		if stage < 3:
			stage += 1
			force_state_change("Transform", true)
			stage_defeated.emit()
		else:
			force_state_change("Dead", true)
			victory.emit()
			var victory_screen = load("res://UI/VictoryScreen.tscn").instantiate()
			get_tree().root.add_child(victory_screen)

func scale_area_destroyed():
	pass
	#TODO Hurt cry or stun

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

func force_state_change(_new_state: String, force := true, restart := false) -> void:
	if current_state != _new_state or restart:
		if force or new_state == "":
			new_state = _new_state
			if DebugInfo.debug_visible:
				print("State force: " + new_state)

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
	%PlayerRay.force_raycast_update()
	player_in_sight = not %PlayerRay.is_colliding()
	player_distance = global_position.distance_to(Game.player.global_position)
	player_direction_clean = Game.player.global_position - global_position
	player_direction_clean.y = 0.0
	player_direction_clean = player_direction_clean.normalized()
	var own_direction_clean = Functions.no_y_normalized(to_global(Vector3.FORWARD) - global_position)
	player_face_angle_signed_rad = own_direction_clean.signed_angle_to(player_direction_clean, Vector3.UP)
	player_face_angle = rad_to_deg(abs(player_face_angle_signed_rad))
	player_dist_arena = Game.player.global_position.distance_to(Game.world.global_position)
#	if DebugInfo.debug_visible:
#		DebugInfo.refresh_info("Player Dist", player_distance)
#		DebugInfo.refresh_info("Player Angle", player_face_angle)

func choose_action():
	var running_total := 0.0
	var cumulative_chances := []
	var flat_chances := []
	var state_names := []
	for state in states:
		if state.has_method("get_probability"):
			if state.natural_state:
				var prob = state.get_probability() * state.get_probabilty_modifier_from_tags()
				if prob != 0.0:
					running_total += prob
					cumulative_chances.append(running_total)
					flat_chances.append(prob)
					state_names.append(state.name)
	var random_choice := randf() * running_total
	for i in range(len(cumulative_chances)):
		if random_choice <= cumulative_chances[i]:
			new_state = state_names[i]
			break
	if new_state == "":
		printerr("No state was chosen")
	if DebugInfo.debug_visible:
		var sorted_index = range(len(state_names))
		sorted_index.sort_custom(func(a,b): return flat_chances[a] > flat_chances[b])
		var debug_states_chances_string := ""
		for index in sorted_index:
			debug_states_chances_string = debug_states_chances_string + str(state_names[index]) + ": " + "%.2f" % (flat_chances[index] / running_total * 100.0) + "%\n"
		DebugInfo.refresh_info("State Chances", debug_states_chances_string)
		print(debug_states_chances_string)

var last_movement_vector : Vector3
func movement_process(delta: float):
	var old_pos := global_position
	var move_vector := Vector3.ZERO
	match movement_type:
		MovementType.DIRECTIONAL:
			var clean_distance = Functions.remove_y_value(global_position).distance_to(Functions.remove_y_value(movement_target_position))
			if clean_distance <= MOVEMENT_TARGET_RANGE:
				movement_type = MovementType.STANDING
				emit_signal("movement_done")
			var clean_direction := global_position.direction_to(movement_target_position)
			clean_direction.y = 0.0
			move_vector = clean_direction.normalized() * movement_speed
		MovementType.CURVED_CLOCKWISE:
			move_vector = global_position.direction_to(movement_pivot_position).cross(Vector3.UP).normalized() * movement_speed
		MovementType.CURVED_COUNTERCLOCKWISE:
			move_vector = global_position.direction_to(movement_pivot_position).cross(Vector3.UP).normalized() * movement_speed
		MovementType.STANDING:
			move_vector = Vector3.ZERO
	var animation_direction = move_vector
	if animation_direction.length() > 0:
		animation_direction = animation_direction.normalized()
	animations.set('parameters/MovementAndIdle/blend_position', global_transform.basis * animation_direction)
	$CollisionBody.velocity = move_vector
	if has_gravity and not is_flying:
		$CollisionBody.velocity.y -= GRAVITY
	$CollisionBody.move_and_slide()
	
	global_position = $CollisionBody.global_position
	$CollisionBody.position = Vector3.ZERO
	
	last_movement_vector = global_position - old_pos
	
	# Fly height animation
	if is_flying:
		if fly_wave_tween == null or (not fly_wave_tween.is_running()):
			fly_wave_tween = get_tree().create_tween()
			fly_wave_tween.tween_method(func(progress): fly_wave_pivot.position.y = fly_wave_curve.sample_baked(progress), 0.0, 1.0, fly_wave_duration)

func turning_process(delta: float):
	if turn_type == TurnType.NO_TURN and movement_type == MovementType.DIRECTIONAL:
		turn_type = TurnType.WITH_MOVEMENT
	var clean_current_direction: Vector3 = Functions.no_y_normalized(to_global(Vector3.FORWARD) - global_position)
	var target_direction: Vector3
	var turning_success := false
	match turn_type:
		TurnType.TURN:
			target_direction = Functions.no_y_normalized(body_direction_target_position - global_position)
		TurnType.FOLLOW:
			if body_direction_target_node == null:
				body_direction_target_node = Game.player
			target_direction = Functions.no_y_normalized(body_direction_target_node.global_position - global_position)
		TurnType.WITH_MOVEMENT:
			target_direction = Functions.no_y_normalized(last_movement_vector)
		TurnType.SPIN:
			target_direction = Functions.no_y_normalized(body_direction_target_direction)
		TurnType.NO_TURN:
			return
	var angle_diff := clean_current_direction.signed_angle_to(target_direction, Vector3.UP)
	var angle_dist : float = angular_speed * delta * sign(angle_diff)
	if abs(angle_dist) > abs(angle_diff):
		angle_dist = angle_diff
		turning_success = true
	self.rotate(Vector3.UP, angle_dist)
	if turning_success:
		emit_signal("turn_done")

func get_nearest_collision(direction: Vector3) -> Vector3:
	var collision_points : Array[Vector3] = []
	for ray in $Rays.get_children():
		if ray is RayCast3D:
			ray.target_position = direction.normalized() * 1000.0
			ray.force_raycast_update()
			collision_points.append(ray.get_collision_point())
	return collision_points.reduce(func(a,b): return a if global_position.distance_squared_to(a) < global_position.distance_squared_to(b) else b)

func get_state_history_index(state_name):
	var index = state_history.slice(-1, -20, -1).find(state_name)
	return 20 if index == -1 else index

func connect_scales():
	gather_scale_meshes(%dragonmesh)
	scale_areas.append_array($ScaleAreas.get_children())
	for scale_mesh in scale_meshes:
		scale_areas.sort_custom(func (a, b): return a.global_position.distance_squared_to(scale_mesh.global_position) < b.global_position.distance_squared_to(scale_mesh.global_position))
		scale_areas[0].add_scale_mesh(scale_mesh)
	for scale_area in scale_areas:
		scale_area.scale_area_damage.connect(refresh_hp)
		scale_area.scale_area_dead.connect(scale_area_destroyed)
		scale_area.order_scale_meshes()

func gather_scale_meshes(node: Node):
	if node is MeshInstance3D:
		if node.name.begins_with("Plane_"):
			scale_meshes.append(node)
	else:
		for c in node.get_children():
			gather_scale_meshes(c)
	
