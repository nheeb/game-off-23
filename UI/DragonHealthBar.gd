extends Node2D

const num_scales :int = 20
const scale_size : int = 34
const max_health : int = 100
const variant_count: int = 2

@export var stage:int = 1
@export var health:int = 100 : set=set_health
var displayed_health : int = 0
var health_increase_delay = 0.05
var health_reduce_delay = 0.05
var last_health_change = 0

var textures = [
	load("res://Assets/Sprites/placeholder/dragon_health_y1.png"),
	load("res://Assets/Sprites/placeholder/dragon_health_y2.png"),
	load("res://Assets/Sprites/placeholder/dragon_health_r1.png"),
	load("res://Assets/Sprites/placeholder/dragon_health_r2.png"),
	load("res://Assets/Sprites/placeholder/dragon_health_b1.png"),
	load("res://Assets/Sprites/placeholder/dragon_health_b2.png"),
]
@onready var baked_randomness = decide_variants()

func decide_variants():
	var rng = RandomNumberGenerator.new()
	var variants = []
	for i in range(num_scales):
		variants.append(rng.randi_range(0,variant_count-1))
	return variants

func set_health(h):
	health = h

func render():
	if baked_randomness == null:
		return
	for c in get_children():
		c.queue_free()
	var scale_offset = scale_size
	var healthbar_width = scale_offset * num_scales
	var offset_x = get_viewport_rect().size.x / 2 - healthbar_width / 2
	var health_per_scale = max_health / num_scales
	for i in range(int(displayed_health/health_per_scale)):
		var s = Sprite2D.new()
		s.texture = textures[(stage-1)*variant_count+baked_randomness[i]]
		s.position.x = offset_x + scale_offset * i
		s.position.y = scale_offset
		add_child(s)
	if displayed_health%health_per_scale > 0:
		var s = Sprite2D.new()
		var i = int(displayed_health/health_per_scale)
		s.texture = textures[(stage-1)*variant_count+baked_randomness[i]]
		s.position.x = offset_x + scale_offset * i
		var falling = (1-(float(displayed_health%health_per_scale) / health_per_scale))
		s.position.y = scale_offset + falling * 16
		s.rotation_degrees = falling * 90
		add_child(s)

func _physics_process(delta):
	last_health_change = max(0, last_health_change - delta)
	if last_health_change == 0:
		if displayed_health < health:
			last_health_change = health_increase_delay
			displayed_health += displayed_health % 5
			displayed_health += min(5, health - displayed_health)
			render()
		elif displayed_health > health:
			last_health_change = health_reduce_delay
			displayed_health -= 1
			render()