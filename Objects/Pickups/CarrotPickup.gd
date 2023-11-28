class_name CarrotPickup extends Area3D
var picked_up = false

func _ready():
	connect('body_entered', _on_body_entered)
	call_deferred("lifetime")


func _on_body_entered(_body):
	pick_up()

func lifetime():
	await get_tree().create_timer(10).timeout
	queue_free()

func pick_up():
	if picked_up:
		return
	picked_up = true
	Game.player.get_health_system().heal(1)
	queue_free()

