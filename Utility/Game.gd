extends Node

@export var scene_path : String

var main_cam: Camera3D
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
