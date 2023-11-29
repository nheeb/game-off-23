extends ItemData

# Optional Override if there should be special conditions
func can_be_obtained():
	return super.can_be_obtained()

func render_item_effect():
	PlayerStats.dodge_boost_speed = 5.0
	PlayerStats.dodge_jump_speed = 5.0

