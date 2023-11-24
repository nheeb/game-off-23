extends Label3D

@export var radius_fade : float = 10
@export var radius_opaque : float  = 4


func _process(delta):
	calculate_visibility(Game.player.global_position)
		
func calculate_visibility(player_position:Vector3):
	var distance : float = global_position.distance_to(player_position)
	if (distance <= radius_opaque):
		modulate.a = 1
	elif (distance <= radius_fade):
		modulate.a = 1 - ((distance - radius_opaque) / (radius_fade - radius_opaque))
	else:
		modulate.a = 0


