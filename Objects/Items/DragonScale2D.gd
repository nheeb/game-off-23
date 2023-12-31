class_name DragonScaleItem extends RigidBody2D

@export var price_weight : int = 1
@export var stage : int = 1: set=set_stage
@export var variant : int = 0: set=set_variant
const variant_count = 3

@onready var sprite : Sprite2D = $Sprite

var textures = [
#	load("res://Assets/Sprites/placeholder/dragon_scale_yellow_1.png"),
#	load("res://Assets/Sprites/placeholder/dragon_scale_yellow_2.png"),
#	load("res://Assets/Sprites/placeholder/dragon_scale_yellow_3.png"),
#	load("res://Assets/Sprites/placeholder/dragon_scale_red_1.png"),
#	load("res://Assets/Sprites/placeholder/dragon_scale_red_2.png"),
#	load("res://Assets/Sprites/placeholder/dragon_scale_red_3.png"),
	load("res://Assets/Sprites/Scales/dragon scales yellow.png"),
	load("res://Assets/Sprites/Scales/dragon scales yellow.png"),
	load("res://Assets/Sprites/Scales/dragon scales yellow.png"),
	load("res://Assets/Sprites/Scales/dragon scales red.png"),
	load("res://Assets/Sprites/Scales/dragon scales red.png"),
	load("res://Assets/Sprites/Scales/dragon scales red.png"),
	load("res://Assets/Sprites/Scales/dragon scales blue.png"),
	load("res://Assets/Sprites/Scales/dragon scales blue.png"),
	load("res://Assets/Sprites/Scales/dragon scales blue.png"),
]

func set_stage(s):
	stage = s
	if stage == 1:
		price_weight = 1
	elif stage == 2:
		price_weight = 2
	elif stage == 3:
		price_weight = 3
#	var size:float = 1.0+(s-1.0)/2.0
#	$Sprite.scale *= size
#	$Collision.scale *= size
	apply_changes()

func set_variant(v):
	variant=v
	apply_changes()

func apply_changes():
	if sprite!=null:
		sprite.texture = textures[variant + (stage-1)*variant_count]

func _ready():
	apply_changes()

func visual_burn():
	can_sleep = false
	sleeping = false
	$Sprite.material = Game.shop.burn_mat
	get_tree().create_tween().tween_property(self, "gravity_scale", -.6, 2.2).from(1.0)
