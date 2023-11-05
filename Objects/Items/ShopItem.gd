class_name ShopItem extends RigidBody2D

var price_weight : int = 10
@export var item_name: String = 'firesword' : set=set_item
@onready var sprite : Sprite2D = get_node("Sprite2D")
var on_scale = false
var shelf_location = null
var shop_ref = null

var items = {
	'firesword': {
		'price': 150,
		'tooltip': 'Deflects fireballs!',
		'stats': {'damage': 2, 'speed': 4, 'armor': 0},
		'texture': load("res://Assets/Sprites/placeholder/weapon_firesword.png"),
	},
	'slasher': {
		'price': 70,
		'tooltip': '',
		'stats': {'damage': 3, 'speed': 5, 'armor': 0},
		'texture': load("res://Assets/Sprites/placeholder/weapon_Slasher.png"),
	},
	'watersword': {
		'price': 50,
		'tooltip': 'Reduces fire damage',
		'stats': {'damage': 2, 'speed': 3, 'armor': 3},
		'texture': load("res://Assets/Sprites/placeholder/weapon_watersword.png")
	},
}

func set_item(i):
	item_name=i
	apply_changes()

func apply_changes():
	if sprite!=null:
		sprite.texture = items[item_name].texture
		price_weight = items[item_name].price
		for child in $Tooltip.get_children():
			child.queue_free()
		var y = 0
		for stat in items[item_name].stats:
			if items[item_name].stats[stat] > 0:
				for i in range(items[item_name].stats[stat]):
					var icon = Sprite2D.new()
					icon.texture = load("res://Assets/Sprites/placeholder/icon_"+stat+".png")
					icon.transform.origin.x = $Tooltip.size.x - i*16
					icon.transform.origin.y += y*16
					$Tooltip.add_child(icon)
				y += 1
		if len(items[item_name].tooltip) > 0:
			var l = Label.new()
			l.text = items[item_name].tooltip
			l.position.y = y*16
			l.size.x = $Tooltip.size.x
			l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			# l.position.x = $Tooltip.size.x - l.font.GetMultilineStringSize()
			$Tooltip.add_child(l)

func _ready():
	apply_changes()


func _on_hover():
	$Tooltip.show()


func _on_mouse_leave():
	$Tooltip.hide()


func _on_area_input(viewport, event, shape_idx):
	if event.is_action_pressed('ShopInteract'):
		shop_ref.toggle_item_on_scale(self)
