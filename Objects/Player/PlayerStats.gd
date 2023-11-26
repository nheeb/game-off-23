extends Node

# Stats here (each one with RESET const for the reset)
# When the player dies we reset the stats and then render the items once the shop is exited

const RESET_MOVEMENT_SPEED_MODIFIER = 1.0
var movement_speed_modifier : float

const RESET_SWORD_SLASH_DAMAGE = 1
var sword_slash_damage: int

enum CHARGED_ATTACK {None, Throw, HeavySlash}
const RESET_CHARGED_ATTACK = CHARGED_ATTACK.None
var charged_attack_type: CHARGED_ATTACK

const RESET_DODGE_RANGE = 1.0
var dodge_range: float

const RESET_JUMP_HEIGHT = 1.0
var jump_height: float

const RESET_DODGE_BOOST_SPEED = 8.0
var dodge_boost_speed: float

enum SPELL_TYPE {None, Water}
var active_spell: SPELL_TYPE = SPELL_TYPE.None

func reset():
	movement_speed_modifier = RESET_MOVEMENT_SPEED_MODIFIER
	sword_slash_damage = RESET_SWORD_SLASH_DAMAGE
	charged_attack_type = RESET_CHARGED_ATTACK
	dodge_range = RESET_DODGE_RANGE
	jump_height = RESET_JUMP_HEIGHT
	dodge_boost_speed = RESET_DODGE_BOOST_SPEED

func reset_and_render_equipped_items():
	reset()
	for item in Items.get_equiped_items():
		print("Activating Item Effect: " + item.name)
		item.render_item_effect()
