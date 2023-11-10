class_name ItemData extends Node

enum SLOTS {WEAPON, RING, BOOT, CONSUMABLE}

# Shop-Exports
@export var slot: SLOTS
@export var price: int
@export var order_index: int
@export var texture: String
@export var not_obtainable := false

var obtained := false

func can_be_obtained() -> bool:
	return not not_obtainable

func equip() -> void:
	Items.equip_item(self)

func obtain() -> void:
	obtained = true
	equip()

func render_item_effect() -> void:
	pass
