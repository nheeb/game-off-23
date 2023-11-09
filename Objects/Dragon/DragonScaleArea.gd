class_name DragonScaleArea extends Node3D

signal scale_area_damage
signal scale_area_dead

var dead := false
var max_hp := 3
var hp : int

func _ready():
	hp = max_hp

func _on_area_3d_area_entered(area):
	if dead: return
	take_damage(1)
	print('take damage')

const FALLEN_SCALE = preload("res://Objects/Projectiles/FallenScale.tscn")
func take_damage(damage: int = 1):
	# Make scales invis
	if $PlaceholderScales.visible:
		for i in range(damage):
			var visible_scales = $PlaceholderScales.get_children().filter(func (x): return x.visible)
			if visible_scales.is_empty(): break
			visible_scales.pick_random().visible = false
			
	# Throw fallen scales
	var direction = global_transform.basis.y + .8 * Vector3.UP + (randf()-.5) * global_transform.basis.x
	direction = direction.normalized()
	#TODO spawn the Fallen Scale
	
	# Process damage
	hp -= damage
	emit_signal("scale_area_damage")
	if hp <= 0:
		emit_signal("scale_area_dead")
		dead = true
		
