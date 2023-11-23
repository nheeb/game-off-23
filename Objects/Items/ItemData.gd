class_name ItemData extends Node

enum SLOTS {WEAPON, BOOT, CONSUMABLE}

# Shop-Exports
@export var order_index: int
@export var slot: SLOTS
@export var price: int
@export var stats: Dictionary = {'damage': 0, 'speed': 0, 'armor': 0}
@export var tooltip := ""
# @export var texture: Texture2D
@export var not_obtainable := false

var obtained := false

func can_be_obtained() -> bool:
	return not not_obtainable

func is_equiped() -> bool:
	return Items.is_equiped(self)

func equip() -> void:
	Items.equip_item(self)

func active_unequip() -> void:
	Items.active_unequip_item(self)

func obtain() -> void:
	obtained = true
	equip()

func render_item_effect() -> void:
	pass
