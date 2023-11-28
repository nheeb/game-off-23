class_name ShopItem extends RigidBody2D

var equipment_object := false

var price_weight : int = 10
var sprite : Sprite2D
var on_scale := false
var shelf_location : Vector2
var item_data_node: ItemData

func apply_changes(item_data: ItemData):
	item_data_node = item_data
	for child in item_data.get_children():
		var dup = child.duplicate()
		add_child(dup)
		dup.position = Vector2.ZERO
		if dup is Sprite2D:
			sprite = dup
			sprite.visible = true
		elif dup is CollisionPolygon2D:
			$Area2D.add_child(dup.duplicate())
	if sprite!=null:
		price_weight = item_data.price
		for child in $Tooltip.get_children():
			child.queue_free()
		var y = 0
		for stat in item_data.stats:
			var stat_value = item_data.stats[stat]
			if stat_value > 0:
				for i in range(stat_value):
					var icon = Sprite2D.new()
					icon.texture = load("res://Assets/Sprites/placeholder/icon_"+stat+".png")
					icon.transform.origin.x = $Tooltip.size.x - i*64
					icon.transform.origin.y += y*64
					$Tooltip.add_child(icon)
				y += 1
		if len(item_data.tooltip) > 0:
			var l = Label.new()
			l.text = item_data.tooltip
			l.position.y = y*64
			l.size.x = $Tooltip.size.x
			l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			# l.position.x = $Tooltip.size.x - l.font.GetMultilineStringSize()
			$Tooltip.add_child(l)

func _on_hover():
	$Tooltip.show()

func _on_mouse_leave():
	$Tooltip.hide()

func _on_area_input(viewport, event, shape_idx):
	if Game.shop.transition: return
	if event.is_action_pressed('ShopInteract'):
		if equipment_object:
			if item_data_node.is_equiped():
				item_data_node.active_unequip()
				Game.shop.place_in_stash(self)
			else:
				item_data_node.equip()
				Game.shop.visually_equip_item(self)
		else:
			Game.shop.toggle_item_on_scale(self)
