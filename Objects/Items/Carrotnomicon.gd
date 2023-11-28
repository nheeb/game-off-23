extends ItemData

# Optional Override if there should be special conditions
func can_be_obtained():
	return super.can_be_obtained()

func render_item_effect():
	PlayerStats.active_spell = PlayerStats.SPELL_TYPE.Carrot
	Game.player_ui.set_item_texture($Sprite2D.texture)

