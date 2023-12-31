extends CanvasLayer

signal fade_done

var show_loading := true

func fade_in(duration: float = 1.0, slight_transparancy: bool = true):
	if not visible:
		$LabelLoading.visible = false
		visible = true
		var tween := get_tree().create_tween().tween_property($SpriteBlack, "modulate:a", .99 if slight_transparancy else 1.0, duration).from(0.0)
		await tween.finished
		$LabelLoading.visible = show_loading
		await get_tree().process_frame
		fade_done.emit()

func fade_out(duration: float = 1.0):
	if visible:
		$LabelLoading.visible = false
		var tween := get_tree().create_tween().tween_property($SpriteBlack, "modulate:a", 0.0, duration)
		await tween.finished
		visible = false
		fade_done.emit()

func _ready():
	visible = false
	$LabelLoading.visible = false
