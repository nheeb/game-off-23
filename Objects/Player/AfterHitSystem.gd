class_name AfterHitSystem extends Node

const PICKUP_CARROT = preload("res://Objects/Pickups/CarrotPickup.tscn")

func player_hit_dragon():
	if PlayerStats.after_hit_dragon_effect == PlayerStats.AFTER_HIT_DRAGON_EFFECT.CarrotProc:
		if randf() * 11.0 < 1.0:
			spawn_carrot()

func spawn_carrot():
	var pos = Game.player.global_position \
	+ Vector3(randf() * 10 - 5, 0.0, randf() * 10 - 5)
	pos = Functions.get_nearest_ground(pos) + Vector3.UP
	var pickup: CarrotPickup = PICKUP_CARROT.instantiate()
	get_tree().get_root().add_child(pickup)
	pickup.transform = Transform3D(Basis(), pos)
