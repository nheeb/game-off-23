extends ItemData

# Optional Override if there should be special conditions
func can_be_obtained() -> bool:
	return super.can_be_obtained()

func render_item_effect() -> void:
	pass
