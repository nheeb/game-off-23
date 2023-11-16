extends Node

@export var scene_path : String

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

var  active_graphics_settings : int
enum GRAPHICS { Potato = 0, Low = 1, Medium = 2, High = 3, Ultra = 4}

func hit_pause():
	return
#	var timer = get_tree().create_timer(.15)
#	get_tree().paused = true
#	await timer.timeout
#	get_tree().paused = false
