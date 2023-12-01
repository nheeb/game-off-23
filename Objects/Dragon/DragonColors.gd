class_name DragonColors extends Node

@onready var dragon : Dragon = get_parent()

@export var main_mesh_path: NodePath
@export var second_mesh_path: NodePath

@onready var main_mesh: MeshInstance3D = get_node(main_mesh_path)
@onready var second_mesh: MeshInstance3D = get_node(second_mesh_path)

@export var mat_skin: Material
@export var mat_dark: Material
@export var mat_wings: Material
@export var mat_scale: Material
@export var mat_yolk: Material

@export var slot_skin: int
@export var slot_skin_legs: int
@export var slot_dark: int
@export var slot_wings: int
@export var slot_scale: int
@export var slot_yolk: int

@export var stage_1_skin: Color
@export var stage_1_dark: Color
@export var stage_1_wings: Color
@export var stage_1_scale: Color
@export var stage_1_yolk: Color

@export var stage_2_skin: Color
@export var stage_2_dark: Color
@export var stage_2_wings: Color
@export var stage_2_scale: Color
@export var stage_2_yolk: Color

@export var stage_3_skin: Color
@export var stage_3_dark: Color
@export var stage_3_wings: Color
@export var stage_3_scale: Color
@export var stage_3_yolk: Color

@export var fallen_mat_scale_1: Material
@export var fallen_mat_yolk_1: Material
@export var fallen_mat_scale_2: Material
@export var fallen_mat_yolk_2: Material
@export var fallen_mat_scale_3: Material
@export var fallen_mat_yolk_3: Material

@export var freeze_mat: Material

var freeze_effect : float = 0.0:
	set(x):
		freeze_effect = x
		freeze_mat.set("shader_parameter/progress", x)

func create_freeze_effect():
	main_mesh.material_overlay = freeze_mat
	second_mesh.material_overlay = freeze_mat

func make_everything_ready():
	insert_own_materials()
	transition_to_stage(1, 1.0)
	create_freeze_effect()

func insert_own_materials():
	main_mesh.set_surface_override_material(slot_skin, mat_skin)
	second_mesh.set_surface_override_material(slot_skin_legs, mat_skin)
	main_mesh.set_surface_override_material(slot_dark, mat_dark)
	main_mesh.set_surface_override_material(slot_wings, mat_wings)
	for scale_mesh in dragon.scale_meshes:
		scale_mesh.set_surface_override_material(slot_scale, mat_scale)
		if scale_mesh.get_surface_override_material_count() > 1:
			scale_mesh.set_surface_override_material(slot_yolk, mat_yolk)

func set_scale_stage(stage: int):
	mat_scale.albedo_color = self.get("stage_" + str(stage) + "_scale")
	mat_yolk.albedo_color = self.get("stage_" + str(stage) + "_yolk")

func transition_to_stage(stage: int, duration: float = 4.0):
	stage = clamp(stage, 1, 3)
	set_scale_stage(stage)
	var color_skin: Color = self.get("stage_" + str(stage) + "_skin")
	var color_dark: Color = self.get("stage_" + str(stage) + "_dark")
	var color_wings: Color = self.get("stage_" + str(stage) + "_wings")
	var tween := get_tree().create_tween().set_parallel()
	tween.tween_property(mat_skin, "albedo_color", color_skin, duration)
	tween.tween_property(mat_dark, "albedo_color", color_dark, duration)
	tween.tween_property(mat_wings, "albedo_color", color_wings, duration)
	await tween.finished
	mat_skin.albedo_color = color_skin
