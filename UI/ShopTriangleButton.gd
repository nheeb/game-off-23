extends Node2D

signal click
var enabled := true

func set_enabled(e: bool):
	enabled = e
	$MeshInstance2D.color = Color.WHITE if enabled else Color.DIM_GRAY

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('ShopInteract') and enabled:
		click.emit()
