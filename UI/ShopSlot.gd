extends Node2D

@export var caption : String = ""
var current_equipped: ShopItem

func _ready():
	$Label.text = caption

func visual_equip(item: ShopItem):
	if current_equipped != null:
		Game.shop.place_in_stash(current_equipped)
	item.global_position = $ItemSpawn.global_position
	current_equipped = item
