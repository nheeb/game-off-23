extends Control


enum SOUNDTYPE { MUSIC , SFX }

func _on_hs_music_value_changed(value):
	%MusicValue.text = str(value)
	change_volume(SOUNDTYPE.MUSIC,value)

func _on_hssfx_value_changed(value):
	%SFXValue.text = str(value)
	change_volume(SOUNDTYPE.SFX,value)

func change_volume(sound_type,value):
	match(sound_type):
		SOUNDTYPE.MUSIC: Music.set_volume(Music.MUSIC_BUS_ID,(value/100))
		SOUNDTYPE.SFX: Music.set_volume(Music.SFX_BUS_ID,(value/100))
	return


func convert_graphics_to_string(value:int) -> String:
	if (value > 4): value = 4
	if (value < 0): value = 0
	match(value):
		Game.GRAPHICS.Potato: return "Very Low"
		Game.GRAPHICS.Low: return "Low"
		Game.GRAPHICS.Medium: return "Medium"
		Game.GRAPHICS.High: return "High"
		Game.GRAPHICS.Ultra: return "Ultra"
	return "ERR_UNAVAILABLE"


func _on_hs_graphic_quality_value_changed(value):
	value = int(value)
	Game.active_graphics_settings = value
	%LBGraphicsSettings.text = convert_graphics_to_string(value)


func _on_bt_return_pressed():
	visible = false
