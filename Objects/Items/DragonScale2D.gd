class_name DragonScaleItem extends RigidBody2D

@export var price_weight : int = 10
@export var stage : int = 1: set=set_stage
@export var variant : int = 0: set=set_variant
const variant_count = 3

@onready var sprite : Sprite2D = $Sprite

var textures = [
	load("res://Assets/Sprites/placeholder/dragon_scale_yellow_1.png"),
	load("res://Assets/Sprites/placeholder/dragon_scale_yellow_2.png"),
	load("res://Assets/Sprites/placeholder/dragon_scale_yellow_3.png"),
	load("res://Assets/Sprites/placeholder/dragon_scale_red_1.png"),
	load("res://Assets/Sprites/placeholder/dragon_scale_red_2.png"),
	load("res://Assets/Sprites/placeholder/dragon_scale_red_3.png"),
	load("res://Assets/Sprites/placeholder/dragon_scale_black_1.png"),
	load("res://Assets/Sprites/placeholder/dragon_scale_black_2.png"),
	load("res://Assets/Sprites/placeholder/dragon_scale_black_3.png"),
]

func set_stage(s):
	stage = s
	var size:float = 1.0+(s-1.0)/2.0
	$Sprite.scale = Vector2(size, size)
	$Collision.scale = Vector2(size, size)
	apply_changes()

func set_variant(v):
	variant=v
	apply_changes()

func apply_changes():
	if sprite!=null:
		sprite.texture = textures[variant + (stage-1)*variant_count]

func _ready():
	apply_changes()
