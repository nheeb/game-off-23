extends Node

var items: Array[ItemData] = []
var equipment: Dictionary = {} # SLOTS -> ItemData
var scale_bank: Array[int] = [8, 0, 0]
const SCALE_RATE = 9

const CHEAT_ALL_COSTS_1 = true

func _ready():
	items.append_array(get_children().filter(func (x): return x is ItemData))
	for s in ItemData.SLOTS.keys():
		equipment[s] = null
	if CHEAT_ALL_COSTS_1:
		for item in get_children():
			item.price = 1

func get_items_for_shop() -> Array[ItemData]:
	var item_array: Array[ItemData] = []
	item_array.append_array(items.filter(func(x): return x.can_be_obtained()))
	item_array.sort_custom(func (a,b): return a.order_index < b.order_index)
	return item_array

func get_obtained_items() -> Array[ItemData]:
	var item_array: Array[ItemData] = []
	item_array.append_array(items.filter(func(x): return x.obtained))
	return item_array

func get_equiped_items() -> Array[ItemData]:
	var item_array: Array[ItemData] = []
	item_array.append_array(equipment.values().filter(func (x): return x != null))
	return item_array

func is_equiped(item: ItemData) -> bool:
	return item in equipment.values()

func equip_item(item: ItemData):
	equipment[item.slot] = item

func active_unequip_item(item: ItemData):
	equipment[item.slot] = null

func get_equiped_item(slot: ItemData.SLOTS) -> ItemData:
	if equipment.has(slot):
		return equipment[slot]
	else:
		return null
