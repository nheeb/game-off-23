extends Control

@export var ui_path : String

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_bt_start_pressed():
	visible = false
	get_tree().change_scene_to_file(Game.scene_path)
	get_tree().root.add_child(load(ui_path).instantiate())
	

