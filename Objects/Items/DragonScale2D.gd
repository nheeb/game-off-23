class_name DragonScaleItem extends RigidBody2D

@export var price_weight : int = 10
@export var stage : int = 1: set=set_stage
@export var variant : int = 0: set=set_variant
const variant_count = 3

@onready var sprite : Sprite2D = get_node("Sprite2D")

var textures = [
	load("res://Assets/Sprites/placeholder/dragon_scale_yellow_1.png"),
	load("res://Assets/Sprites/placeholder/dragon_scale_yellow_2.png"),
	load("res://Assets/Sprites/placeholder/dragon_scale_yellow_3.png"),
]

func set_stage(s):
	stage=s
	apply_changes()
	
func set_variant(v):
	variant=v
	apply_changes()

func apply_changes():
	if sprite!=null:
		sprite.texture = textures[variant + (stage-1)*variant_count]

func _ready():
	apply_changes()
