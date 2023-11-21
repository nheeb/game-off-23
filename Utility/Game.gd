extends Node

@export var scene_path : String
@export var shop_scene_path: String

var main_cam: PlayerCamera
var mouse_layer: MouseDetectionLayer
var player: Player
var player_health_system : HealthSystem :
	set(system):
		player_health_system = system
		PlayerUI.set_health_system(system)

var player_ui : CanvasLayer
var dragon: Dragon
var world: Node3D

enum GRAPHICS {Potato = 0, Low = 1, Medium = 2, High = 3, Ultra = 4}
signal graphic_settings_changed(new_settings: GRAPHICS)
var active_graphics_settings : GRAPHICS : 
	set(x):
		active_graphics_settings = x
		graphic_settings_changed.emit(x)

enum GAME_STATE {Menu, Intro, Cutscene, Battle, Pause, Shop, Victory}
var current_game_state: GAME_STATE = GAME_STATE.Menu

func hit_pause():
	return
#	var timer = get_tree().create_timer(.15)
#	get_tree().paused = true
#	await timer.timeout
#	get_tree().paused = false

func load_shop():
	get_tree().change_scene_to_file(shop_scene_path)
	current_game_state = GAME_STATE.Shop

func load_game(with_intro : bool = true):
	get_tree().change_scene_to_file(scene_path)
	current_game_state = GAME_STATE.Intro if with_intro else GAME_STATE.Battle
