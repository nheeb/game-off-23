extends Node

var items: Array[ItemData] = []
var equipment: Dictionary = {} # SLOTS -> ItemData

func _ready():
	items.append_array(get_children().filter(func (x): return x is ItemData))
	for s in ItemData.SLOTS.keys():
		equipment[s] = null

func get_items_for_shop() -> Array[ItemData]:
	var item_array: Array[ItemData] = []
	item_array.append_array(items.filter(func(x): return x.can_be_obtained()))
	item_array.sort_custom(func (a,b): return a.order_index > b.order_index)
	return item_array

func get_obtained_items() -> Array[ItemData]:
	var item_array: Array[ItemData] = []
	item_array.append_array(items.filter(func(x): return x.obtained))
	return item_array

func get_equiped_items() -> Array[ItemData]:
	var item_array: Array[ItemData] = []
	item_array.append_array(equipment.values().filter(func (x): x != null))
	return item_array

func equip_item(item: ItemData):
	equipment[item.slot] = item

func get_equiped_item(slot: ItemData.SLOTS) -> ItemData:
	if equipment.has(slot):
		return equipment[slot]
	else:
		return null
