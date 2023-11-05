extends Control


@export var world : Node
#@export var pause_menu : Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	%Settings.visible = false


func _process(delta):
	if (Input.is_action_just_pressed("PauseGame")):
		if (%Settings.visible):
			%Settings.visible = false
			return
		visible = switch_pause_state(world)
		


func switch_pause_state(node) -> bool:
	if (node == null):
		node = get_tree()
	node.paused = !get_tree().paused
	return node.paused


func _on_bt_settings_pressed():
	%Settings.visible = true


func _on_bt_resume_pressed():
	visible = switch_pause_state(world)


func _on_bt_exit_pressed():
	get_tree().quit()

enum SOUNDTYPE { MUSIC , SFX }

func _on_hs_music_value_changed(value):
	%MusicValue.text = str(value)
	change_volume(SOUNDTYPE.MUSIC,value)

func _on_hssfx_value_changed(value):
	%SFXValue.text = str(value)
	change_volume(SOUNDTYPE.SFX,value)

func change_volume(sound_type,value):
	match(sound_type):
		SOUNDTYPE.MUSIC: pass
		SOUNDTYPE.SFX: pass
	return



