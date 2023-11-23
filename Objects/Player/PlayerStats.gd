extends Node

# Stats here (each one with RESET const for the reset)
# When the player dies we reset the stats and then render the items once the shop is exited

const RESET_MOVEMENT_SPEED_MODIFIER = 1.0
var movement_speed_modifier : float

const RESET_SWORD_SLASH_DAMAGE = 1
var sword_slash_damage: int

var sword_throw_unlocked: bool = false

func reset():
	movement_speed_modifier = RESET_MOVEMENT_SPEED_MODIFIER
	sword_slash_damage = RESET_SWORD_SLASH_DAMAGE

func reset_and_render_equipped_items():
	reset()
	for item in Items.get_equiped_items():
		item.render_item_effect()
