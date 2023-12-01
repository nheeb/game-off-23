class_name Shop extends Node2D

const max_scale_angle = 20
@onready var scale_spawn_location = $scale_spawn_point.transform.origin
const scale_spawn_variation = 100
@export var scale_count_yellow : int = 2 : set=set_yellow_scale
@export var scale_count_red : int = 2 : set=set_red_scale
@export var scale_count_black : int = 2 : set=set_black_scale
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
var spawned_scale_count = [0,0,0]

@onready var left_scale_original_pos = get_node('Scale/Left').transform.origin
@onready var left_scale_connect_original_pos = get_node('Scale/ScaleShaft/left_connect').get_relative_transform_to_parent(get_node('Scale')).origin
@onready var right_scale_original_pos = get_node('Scale/Right').transform.origin
@onready var right_scale_connect_original_pos = get_node('Scale/ScaleShaft/right_connect').get_relative_transform_to_parent(get_node('Scale')).origin

@export var burn_mat: Material

func set_yellow_scale(new_scale_count):
	scale_count_yellow = new_scale_count
	clear_scales()
func set_red_scale(new_scale_count):
	scale_count_red = new_scale_count
	clear_scales()
func set_black_scale(new_scale_count):
	scale_count_black = new_scale_count
	clear_scales()

func spawn_scale(stage):
	var s = scale_scene.instantiate()
	s.stage = stage
	s.variant = rng.randi_range(0, 2)
	s.transform.origin = scale_spawn_location
	s.transform.origin.x += rng.randi_range(-scale_spawn_variation, scale_spawn_variation)
	s.transform.origin.y += rng.randi_range(-scale_spawn_variation, scale_spawn_variation)
	scales.append(s)
	scale_container.add_child(s)
	spawned_scale_count[stage-1] += 1

func clear_scales():
	if scale_container != null:
		for child in scale_container.get_children():
			child.queue_free()
		scales = []
		spawned_scale_count = [0,0,0]

func toggle_item_on_scale(item_ref: RigidBody2D):
	if item_ref.on_scale:
		item_ref.freeze = true
		item_ref.on_scale = false
		item_ref.global_position = item_ref.shelf_location
		item_ref.rotation = 0
	else:
		item_ref.freeze = false
		item_ref.on_scale = true
		item_ref.shelf_location = item_ref.global_position
		item_ref.global_position = $Scale/Right.global_position

func _ready():
	Game.shop = self
	scale_count_yellow = Items.scale_bank[0] / Items.SCALE_RATE
	scale_count_red = Items.scale_bank[1] / Items.SCALE_RATE
	scale_count_black = Items.scale_bank[2] / Items.SCALE_RATE
	load_items()
	setup_shop_slots()

func scale_weight():
	var weight = 0
	for body in $Scale/Left/scales_paid.get_overlapping_bodies():
		if 'price_weight' in body and body != scale_in_hand:
			body = body as RigidBody2D
			if body.get_contact_count() != 0:
				weight += body.price_weight
	return weight

func item_weight():
	var weight = 0
	for body in $Scale/Right/scales_paid.get_overlapping_bodies():
		if 'price_weight' in body and body != scale_in_hand:
			body = body as RigidBody2D
			if body.get_contact_count() != 0:
				weight += body.price_weight
	return weight

func catch_fire():
	for x in items_in_fire:
		x.visual_burn()

var isSelected : bool = false
var active_scale : :
	set(new_scale):
		if (new_scale == null): return
		if (new_scale == active_scale): return
		else:
			active_scale = new_scale
			isSelected = false

func handle_scale_dragging(delta):
	var mousePos = get_local_mouse_position()
	if Input.is_action_pressed("ShopInteract"):
		if selected_scale != null:
			active_scale = selected_scale
			if (!isSelected):
				%AudioStreamScale.play()
				isSelected = true
			scale_in_hand = selected_scale
			selected_scale.gravity_scale = 0
			selected_scale.linear_damp = 10
			var distance = mousePos - selected_scale.transform.origin
			var SPRING_CONSTANT = 200
			if abs(distance.x) + abs(distance.y) > 15:
				selected_scale.apply_central_impulse(SPRING_CONSTANT * (mousePos - selected_scale.transform.origin).normalized())
	else:
		isSelected = false
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
	var shaft_angle_target
	if shaft_angle_time_left > 0.0:
		shaft_angle_target = last_shaft_angle
	else:
		shaft_angle_target = max(-max_scale_angle, min(max_scale_angle, (item_weight()-scale_weight())))
	if shaft_angle_target != last_shaft_angle:
		last_shaft_angle = shaft_angle_target
		shaft_angle_time_left = 1
	shaft_angle_time_left = max(0.0, shaft_angle_time_left - delta*1.5)
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
	if spawned_scale_count[0] < scale_count_yellow:
		spawn_scale(1)
	if spawned_scale_count[1] < scale_count_red:
		spawn_scale(2)
	if spawned_scale_count[2] < scale_count_black:
		spawn_scale(3)

func _physics_process(delta):
	spawn_initial_scales()
	handle_scale_dragging(delta)
	handle_fire(delta)
	handle_scale_angle(delta)
	handle_buy_button_visuals()

func handle_fire(delta):
	if fire_duration_left>0:
		fire_duration_left = max(0, fire_duration_left - delta)
		burn_mat.set("shader_parameter/progress", 1.0 - (fire_duration_left / 2.5))
		if fire_duration_left < 0.1 and len(items_in_fire) > 0:
			for x in items_in_fire:
				x.queue_free()
			items_in_fire = []
#		if fire_duration_left == 0:
#			$Scale/Left/Fire.hide()
#			$Scale/Left/Fire.stop()
#			$Scale/Right/Fire.hide()
#			$Scale/Right/Fire.stop()

func _on_buy_pressed():
	%AudioStreamPlayer.play()
	if transition: return
	if scale_weight() >= item_weight():
		fire_duration_left = 2.5
#		$Scale/Left/Fire.show()
#		$Scale/Left/Fire.play()
#		$Scale/Right/Fire.show()
#		$Scale/Right/Fire.play()
		# todo: change player owned items
		for item in get_node("Scale/Right/scales_paid").get_overlapping_bodies():
			if item is ShopItem:
				items_in_fire.append(item)
				item.item_data_node.obtain()
			elif item is DragonScaleItem:
				var _scale = item
				items_in_fire.append(_scale)
				Items.scale_bank[_scale.stage-1] -= Items.SCALE_RATE
		for _scale in get_node("Scale/Left/scales_paid").get_overlapping_bodies():
			if _scale is DragonScaleItem:
				items_in_fire.append(_scale)
				Items.scale_bank[_scale.stage-1] -= Items.SCALE_RATE

		catch_fire()

const ITEM = preload("res://Objects/Items/ShopItem.tscn")
 
var item_count := 0
func load_items():
	var PADDING = get_viewport_rect().size.y / 4
	var PAGE_SIZE = get_viewport_rect().size.y
	item_count = 0 
	for item_data in Items.get_items_for_shop():
		var new_item := ITEM.instantiate()
		%Items.add_child(new_item)
		new_item.position.y = (item_count / 3) * PAGE_SIZE + (item_count % 3) * PADDING
		new_item.apply_changes(item_data)
		item_count += 1
	%ShopTriangleButtonUp.set_enabled(false)
	%ShopTriangleButtonDown.set_enabled(true if item_count > 3 else false)

var transition := false
var item_cursor := 0

func _on_shop_triangle_button_up_click():
	%AudioStreamPlayer.play()
	scroll_items(1)

func _on_shop_triangle_button_down_click():
	%AudioStreamPlayer.play()
	scroll_items(-1)

func scroll_items(direction: int):
	if transition: return
	item_cursor += - direction * 3
	%ShopTriangleButtonUp.set_enabled(true if item_cursor > 0 else false)
	%ShopTriangleButtonDown.set_enabled(true if item_cursor + 3 < item_count else false)
	transition = true
	var PAGE_SIZE = get_viewport_rect().size.y
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK).set_parallel()
	tween.tween_interval(1.5)
	for item in %Items.get_children():
		item = item as ShopItem
		if item.on_scale:
			item.shelf_location.y += direction * PAGE_SIZE
		else:
			tween.tween_property(item, "position:y", item.position.y + direction * PAGE_SIZE, 1.5)
	await tween.finished
	transition = false


var equipment_menu := false

func _on_exit_pressed():
	%AudioStreamPlayer.play()
	if transition: return
	if not equipment_menu:
		if Items.get_items_for_shop().is_empty():
			%Cheers.visible = true
		transition = true
		var tween := get_tree().create_tween()
		tween.tween_property($Camera2D, "position:x", $Camera2D.position.x + get_viewport_rect().size.x, 1.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		equipment_menu = true
		setup_equipment()
		await tween.finished
		unfreeze_equipment()
		transition = false

func unfreeze_equipment():
	for item in %Equipment.get_children():
		if item is ShopItem:
			item.freeze = false

func setup_equipment():
	for item_data in Items.get_obtained_items():
		var item = ITEM.instantiate()
		%Equipment.add_child(item)
		item.equipment_object = true
		item.apply_changes(item_data)
		if item_data.is_equiped():
			visually_equip_item(item)
		else:
			place_in_stash(item)

func place_in_stash(item: ShopItem, hide_tooltip := false):
	if not item.equipment_object:
		printerr("Wrong item state: Not equipment")
	item.global_position = %EquipmentItemSpawn.global_position + Vector2.RIGHT * randi_range(-300, 300)
	if hide_tooltip:
		var slot = shop_slots[item.item_data_node.slot]
		slot.show_tooltip(false)

func visually_equip_item(item: ShopItem):
	var slot = shop_slots[item.item_data_node.slot]
	slot.show_tooltip(true)
	slot.visual_equip(item)

var shop_slots := {}
func setup_shop_slots():
	shop_slots[ItemData.SLOTS.WEAPON] = %WeaponSlot
	shop_slots[ItemData.SLOTS.BOOT] = %BootsSlot
	shop_slots[ItemData.SLOTS.CONSUMABLE] = %ConsumableSlot

func _on_fight_pressed():
	Game.player_ui.set_carrot(0)
	%AudioStreamPlayer.play()
	if transition: return
	transition = true
	BlackScreen.fade_in()
	await BlackScreen.fade_done
	Game.load_game(false)

