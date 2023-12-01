extends Node3D

signal spell_cast

func signal_spell_cast(): spell_cast.emit()

func _physics_process(delta):
	global_position = Game.player.global_position + Vector3.UP * 2.0

func set_color(color: Color):
	$book/BookLeft.mesh.surface_get_material(3).albedo_color = color
	$book/PageMiddle.material_override.set("shader_parameter/text_col_magic", color)

func _ready():
	pass
	# HIER NIELS MAGIC SPELL SOUND
