class_name ShopItem extends RigidBody2D

var price_weight : int = 10
@export var item_name: String = 'firesword'
@onready var sprite : Sprite2D = get_node("Sprite2D")
var on_scale = false
var shelf_location = null
var shop_ref = null

func apply_changes(item_data: ItemData):
	if sprite!=null:
		sprite.texture = item_data.texture
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
					icon.transform.origin.x = $Tooltip.size.x - i*16
					icon.transform.origin.y += y*16
					$Tooltip.add_child(icon)
				y += 1
		if len(item_data.tooltip) > 0:
			var l = Label.new()
			l.text = item_data.tooltip
			l.position.y = y*16
			l.size.x = $Tooltip.size.x
			l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			# l.position.x = $Tooltip.size.x - l.font.GetMultilineStringSize()
			$Tooltip.add_child(l)

func _on_hover():
	$Tooltip.show()

func _on_mouse_leave():
	$Tooltip.hide()

func _on_area_input(viewport, event, shape_idx):
	if event.is_action_pressed('ShopInteract'):
		shop_ref.toggle_item_on_scale(self)
