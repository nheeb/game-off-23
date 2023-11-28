class_name CarrotPickup extends Area3D
var picked_up = false

@export var persist = false

func _ready():
	connect('body_entered', _on_body_entered)
	if not persist:
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
	Game.player.get_eating_system().eat()
	queue_free()

