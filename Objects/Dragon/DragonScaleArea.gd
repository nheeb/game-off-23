class_name DragonScaleArea extends Node3D

signal scale_area_damage
signal scale_area_dead

var dead := false
var max_hp := 3
var hp : int

@onready var hit_area: Area3D = $Area3D

const INVINC_TIME = .15

var scale_meshes: Array[MeshInstance3D] = []
var scales_per_damage := 0
const VISUAL_BONUS_SCALES = .2
var next_scale_index := 0

func _ready():
	hp = max_hp
	
func _physics_process(delta):
	var overlapping = hit_area.get_overlapping_areas()
	for hit_object in overlapping:
		if hit_object is PlayerHurtArea and hit_object.is_attacking():
			_on_hit(hit_object)

func _on_hit(hit_object: PlayerHurtArea):
	if dead: return
	if $Timer.is_stopped() and not Game.dragon.invincible:
		take_damage(hit_object.damage)
		hit_object.set_attacking(false)
		$Timer.start(INVINC_TIME)

const FALLEN_SCALE = preload("res://Objects/Projectiles/FallenScale.tscn")
const HIT_EFFECT = preload("res://Objects/Effects/HitEffect.tscn")
func take_damage(damage: int = 1):
	# Very dirty and scuffed implementaton of damage boost
	damage = max(PlayerStats.sword_slash_damage, damage)
	
	# Player after hit hook
	Game.player.get_after_hit_system().player_hit_dragon()
	
	# Hit effect
	var hit_effect = HIT_EFFECT.instantiate()
	Game.world.add_child(hit_effect)
	hit_effect.global_position = global_position
	%AudioDragonBody.stream = Game.dragon.sound_dragon_damage.pick_random()
	%AudioDragonBody.play()
	%AudioDragonScales.stream = Game.dragon.sound_scale_drop.pick_random()
	%AudioDragonScales.play()
	Game.hit_pause()
	
	# Make scales invis placeholder
	if $PlaceholderScales.visible:
		for i in range(damage):
			var visible_scales = $PlaceholderScales.get_children().filter(func (x): return x.visible)
			if visible_scales.is_empty(): break
			visible_scales.pick_random().visible = false
	
	# Make scales invis
	if damage >= hp:
		for m in scale_meshes: m.visible = false
	else:
		for i in range(damage * scales_per_damage):
			scale_meshes[next_scale_index + i].visible = false
		next_scale_index += damage * scales_per_damage
	
	# Throw fallen scales
	var fallen_scale_count = randi_range(2,4)
#	if randf_range(0, 5) == 0:
#		fallen_scale_count -= 1
	for i in range(fallen_scale_count):
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

func add_scale_mesh(mesh: MeshInstance3D):
	scale_meshes.append(mesh)

func order_scale_meshes():
	scale_meshes.sort_custom(func (a, b): return a.global_position.distance_squared_to(self.global_position) < b.global_position.distance_squared_to(self.global_position))
	var scale_count := len(scale_meshes)
	var bonus_scales := int(scale_count * VISUAL_BONUS_SCALES)
	bonus_scales += (scale_count - bonus_scales) % max_hp
	scales_per_damage = (scale_count - bonus_scales) / max_hp

func reset_hp():
	next_scale_index = 0
	hp = max_hp
	dead = false
