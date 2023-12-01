extends Control

@export var ui_path : String

func _ready():
	%Settings.visible = false
	PlayerUI.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_bt_start_pressed():
	visible = false
	#get_tree().change_scene_to_file(Game.scene_path)
	BlackScreen.fade_in(1.0)
	await BlackScreen.fade_done
	Game.load_game()
	PlayerUI.visible = true
	Music.fade_out(2)
#	get_tree().root.add_child(load(ui_path).instantiate())
#	if (Game.debug):
#		get_node("/root/DebugInfo")
#		get_tree().root.add_child(load("res://Utility/DebugInfo.tscn").instantiate())

func _on_bt_settings_pressed():
	%Settings.visible = true
