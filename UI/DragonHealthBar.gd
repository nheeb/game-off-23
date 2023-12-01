extends Node2D

const hp_frames : int = 12
const num_scales : int = 8
const scale_size : int = 34
const max_health : int = num_scales * 3 * hp_frames
const variant_count : int = 2

@export var stage : int = 1
@export var health : int = max_health : set=set_health
var displayed_health : int = 0
var health_increase_delay = 0.05
var health_reduce_delay = 0.05
var last_health_change = 0

var textures = [
	load("res://Assets/Sprites/Scales/dragon scales yellow.png"),
	load("res://Assets/Sprites/Scales/dragon scales yellow.png"),
	load("res://Assets/Sprites/Scales/dragon scales red.png"),
	load("res://Assets/Sprites/Scales/dragon scales red.png"),
	load("res://Assets/Sprites/Scales/dragon scales blue.png"),
	load("res://Assets/Sprites/Scales/dragon scales blue.png"),
#	load("res://Assets/Sprites/placeholder/dragon_health_b1.png"),"res://Assets/Sprites/Scales/dragon scales blue.png"
]
@onready var baked_randomness = decide_variants()

func decide_variants():
	var rng = RandomNumberGenerator.new()
	var variants = []
	for i in range(num_scales):
		variants.append(rng.randi_range(0,variant_count-1))
	return variants

func set_health(h):
	health = h * hp_frames

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
		s.scale = Vector2.ONE * .2
		add_child(s)
	if displayed_health%health_per_scale > 0:
		var s = Sprite2D.new()
		var i = int(displayed_health/health_per_scale)
		s.texture = textures[(stage-1)*variant_count+baked_randomness[i]]
		s.position.x = offset_x + scale_offset * i
		var falling = (1-(float(displayed_health%health_per_scale) / health_per_scale))
		s.position.y = scale_offset + falling * 16
		s.rotation_degrees = falling * 70
		s.scale = Vector2.ONE * .2
		add_child(s)


var latest_scale_amount : int = 0 :
	set(value):
		if (value > latest_scale_amount):
			Music.play_scale_build_up_sound(value)
		latest_scale_amount = value

func _physics_process(delta):
	latest_scale_amount = get_child_count()
	if Game.current_game_state == Game.GAME_STATE.Battle:
		visible = true
		stage = Game.dragon.stage
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
#	else:
#		visible = false
