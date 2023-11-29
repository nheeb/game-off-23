extends Node

# Stats here (each one with RESET const for the reset)
# When the player dies we reset the stats and then render the items once the shop is exited

const RESET_MOVEMENT_SPEED_MODIFIER = 1.0
var movement_speed_modifier : float

const RESET_SWORD_SLASH_DAMAGE = 1
var sword_slash_damage: int

enum CHARGED_ATTACK {None, Throw, HeavySlash, CarrotMissile}
const RESET_CHARGED_ATTACK = CHARGED_ATTACK.None
var charged_attack_type: CHARGED_ATTACK

const RESET_DODGE_RANGE = 1.0
var dodge_range: float

const RESET_JUMP_HEIGHT = 1.0
var jump_height: float

const RESET_DODGE_BOOST_SPEED = 0.0
var dodge_boost_speed: float

const RESET_DODGE_JUMP_SPEED = 0.0
var dodge_jump_speed: float

enum SPELL_TYPE {None, Water, Carrot}
var active_spell: SPELL_TYPE = SPELL_TYPE.None

const RESET_CARROTS_PER_HEALTH = 3
var carrots_per_health: int

func reset():
	movement_speed_modifier = RESET_MOVEMENT_SPEED_MODIFIER
	sword_slash_damage = RESET_SWORD_SLASH_DAMAGE
	charged_attack_type = RESET_CHARGED_ATTACK
	dodge_range = RESET_DODGE_RANGE
	jump_height = RESET_JUMP_HEIGHT
	dodge_boost_speed = RESET_DODGE_BOOST_SPEED
	dodge_jump_speed = RESET_DODGE_JUMP_SPEED
	carrots_per_health = RESET_CARROTS_PER_HEALTH

func reset_and_render_equipped_items():
	reset()
	for item in Items.get_equiped_items():
		print("Activating Item Effect: " + item.name)
		item.render_item_effect()
	Game.player_ui.set_item_visible(active_spell != SPELL_TYPE.None)
	await get_tree().process_frame
	Game.world.everything_ready.connect(func (): Game.player.get_magic_casting().apply_cooldown(8), CONNECT_ONE_SHOT)
		
