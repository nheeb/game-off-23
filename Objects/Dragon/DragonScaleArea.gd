class_name DragonScaleArea extends Node3D

signal scale_area_damage
signal scale_area_dead

var dead := false
var max_hp := 3
var hp : int

const INVINC_TIME = .15

func _ready():
	hp = max_hp

func _on_area_3d_area_entered(area):
	if dead: return
	if $Timer.is_stopped():
		take_damage(1)
		$Timer.start(INVINC_TIME)
	#print('take damage')

const FALLEN_SCALE = preload("res://Objects/Projectiles/FallenScale.tscn")
func take_damage(damage: int = 1):
	# Make scales invis
	if $PlaceholderScales.visible:
		for i in range(damage):
			var visible_scales = $PlaceholderScales.get_children().filter(func (x): return x.visible)
			if visible_scales.is_empty(): break
			visible_scales.pick_random().visible = false
			
	# Throw fallen scales
	for i in range(3):
		var direction = global_transform.basis.y + .7 * Vector3.UP + 2.0 * (randf()-.5) * global_transform.basis.x
		direction = direction.normalized() * randf_range(2.5, 4.5)
		#TODO spawn the Fallen Scale
		var fallen_scale = FALLEN_SCALE.instantiate()
		Game.world.add_child(fallen_scale)
		fallen_scale.global_position = self.global_position + randf_range(-.2, .6) * Vector3.UP
		fallen_scale.activate(direction)
	
	# Process damage
	hp -= damage
	emit_signal("scale_area_damage")
	if hp <= 0:
		emit_signal("scale_area_dead")
		dead = true
		
