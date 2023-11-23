extends Control


@export var world : Node
#@export var pause_menu : Control
var previous_game_state

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	%Settings.visible = false


func _process(delta):
	if (Input.is_action_just_pressed("PauseGame")):
		if (%Settings.visible):
			%Settings.visible = false
			return
		var pause_menu_active := switch_pause_state(world)
		visible = pause_menu_active
		mouse_filter = Control.MOUSE_FILTER_PASS if pause_menu_active else Control.MOUSE_FILTER_IGNORE
		if pause_menu_active:
			previous_game_state = Game.current_game_state
			Game.current_game_state = Game.GAME_STATE.Pause
		else:
			Game.current_game_state = previous_game_state

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


	
