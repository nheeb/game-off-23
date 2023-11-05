extends Node2D

const max_scale_angle = 20
const scale_spawn_location = Vector2(100, 50)
const scale_spawn_variation = 10
@export var scale_count_yellow : int = 2 : set=change_scale_count
var scales = []
var scale_scene = load("res://Objects/Items/DragonScale2D.tscn")
@onready var scale_container = get_node("DragonScale")
var rng = RandomNumberGenerator.new()
var selected_scale : RigidBody2D = null
var scale_in_hand = null
var shaft_angle : float = 0
var shaft_angle_time_left : float = 0
var last_shaft_angle = 0
var fire_duration_left = 0
var items_in_fire = []

@onready var left_scale_original_pos = get_node('Scale/Left').transform.origin
@onready var left_scale_connect_original_pos = get_node('Scale/ScaleShaft/left_connect').get_relative_transform_to_parent(get_node('Scale')).origin
@onready var right_scale_original_pos = get_node('Scale/Right').transform.origin
@onready var right_scale_connect_original_pos = get_node('Scale/ScaleShaft/right_connect').get_relative_transform_to_parent(get_node('Scale')).origin

func change_scale_count(new_scale_count):
	scale_count_yellow = new_scale_count
	clear_scales()

func spawn_yellow_scale():
	var s = scale_scene.instantiate()
	s.stage = 1
	s.variant = rng.randi_range(0, 2)
	s.transform.origin = scale_spawn_location
	s.transform.origin.x += rng.randi_range(-scale_spawn_variation, scale_spawn_variation)
	scales.append(s)
	scale_container.add_child(s)

func clear_scales():
	if scale_container != null:
		for child in scale_container.get_children():
			child.queue_free()
		scales = []

func toggle_item_on_scale(item_ref):
	if item_ref.on_scale:
		item_ref.freeze = true
		item_ref.on_scale = false
		item_ref.transform.origin = item_ref.shelf_location
		item_ref.rotation = 0
	else:
		item_ref.freeze = false
		item_ref.on_scale = true
		item_ref.shelf_location = item_ref.transform.origin
		item_ref.transform.origin = $Scale/Right.global_transform.origin

func _ready():
	for item in $Items.get_children():
		item.shop_ref = self

func scale_weight():
	var weight = 0
	for body in $Scale/Left/scales_paid.get_overlapping_bodies():
		if 'price_weight' in body and body != scale_in_hand:
			weight += body.price_weight
	return weight

func item_weight():
	var weight = 0
	for body in $Scale/Right/scales_paid.get_overlapping_bodies():
		if 'price_weight' in body and body != scale_in_hand:
			weight += body.price_weight
	return weight

func catch_fire():
	pass

func handle_scale_dragging(delta):
	var mousePos = get_local_mouse_position()
	if Input.is_action_pressed("ShopInteract"):
		if selected_scale != null:
			scale_in_hand = selected_scale
			selected_scale.gravity_scale = 0
			selected_scale.linear_damp = 10
			var distance = mousePos - selected_scale.transform.origin
			var SPRING_CONSTANT = 200
			if abs(distance.x) + abs(distance.y) > 15:
				selected_scale.apply_central_impulse(SPRING_CONSTANT * (mousePos - selected_scale.transform.origin).normalized())
	else:
		if scale_in_hand != null:
			selected_scale.gravity_scale = 1
			selected_scale.linear_damp = 0
		scale_in_hand = null
		var space = get_world_2d().direct_space_state
		var parameters = PhysicsPointQueryParameters2D.new()
		parameters.position= mousePos
		parameters.collide_with_areas = false
		parameters.collide_with_bodies = true
		parameters.collision_mask = 1
		var hover = space.intersect_point(parameters, 1)
		if hover.size() > 0 and hover[0].collider is DragonScaleItem:
			selected_scale = hover[0].collider
		else:
			selected_scale = null

func handle_scale_angle(delta):
	# todo: make logarithmic scale?
	var shaft_angle_target = max(-max_scale_angle, min(max_scale_angle, (item_weight()-scale_weight())/10))
	if shaft_angle_target != last_shaft_angle:
		last_shaft_angle = shaft_angle_target
		shaft_angle_time_left = 1
	shaft_angle_time_left = max(0.0, shaft_angle_time_left - delta)
	shaft_angle = shaft_angle_target * (1 - shaft_angle_time_left) + shaft_angle * shaft_angle_time_left
	get_node('Scale/ScaleShaft').rotation = deg_to_rad(shaft_angle)
	var new_pos = get_node('Scale/ScaleShaft/left_connect').get_relative_transform_to_parent(get_node('Scale')).origin
	get_node('Scale/Left').transform.origin = new_pos - left_scale_connect_original_pos + left_scale_original_pos
	new_pos = get_node('Scale/ScaleShaft/right_connect').get_relative_transform_to_parent(get_node('Scale')).origin
	get_node('Scale/Right').transform.origin = new_pos - right_scale_connect_original_pos + right_scale_original_pos

func handle_buy_button_visuals():
	# debug weight
	get_node("Label").text = str(scale_weight())
	$Control/Buy.disabled = scale_weight() < item_weight() or item_weight() == 0
	
	

func spawn_initial_scales():
	if len(scales) < scale_count_yellow:
		spawn_yellow_scale()

func _physics_process(delta):
	spawn_initial_scales()
	handle_scale_dragging(delta)
	handle_scale_angle(delta)
	handle_buy_button_visuals()
	handle_fire(delta)

func handle_fire(delta):
	if fire_duration_left>0:
		fire_duration_left = max(0, fire_duration_left - delta)
		if fire_duration_left < 0.4 and len(items_in_fire) > 0:
			for x in items_in_fire:
				x.queue_free()
			items_in_fire = []
		if fire_duration_left == 0:
			$Scale/Left/Fire.hide()
			$Scale/Left/Fire.stop()
			$Scale/Right/Fire.hide()
			$Scale/Right/Fire.stop()
		

func _on_buy_pressed():
	if scale_weight() >= item_weight():
		fire_duration_left = 1.5
		$Scale/Left/Fire.show()
		$Scale/Left/Fire.play()
		$Scale/Right/Fire.show()
		$Scale/Right/Fire.play()
		# todo: change player owned items
		for item in get_node("Scale/Right/scales_paid").get_overlapping_bodies():
			if item is ShopItem:
				items_in_fire.append(item)
				print('bought '+item.item_name)
		for scale in get_node("Scale/Left/scales_paid").get_overlapping_bodies():
			if scale is DragonScaleItem:
				items_in_fire.append(scale)
		catch_fire()
