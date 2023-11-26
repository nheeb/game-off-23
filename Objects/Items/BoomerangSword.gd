extends ItemData

# Optional Override if there should be special conditions
func can_be_obtained():
	return super.can_be_obtained()

func render_item_effect():
	PlayerStats.charged_attack_type = PlayerStats.CHARGED_ATTACK.Throw

