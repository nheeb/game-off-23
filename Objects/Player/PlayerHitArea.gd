extends Area3D

var current_intersections: Array = []

@onready var health_system = $"../Behaviours/HealthSystem"
@onready var animation_tree: AnimationTree = $"../animations"

func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	health_system.connect("damage_taken", _on_damage_taken)

func _on_area_entered(area):
	current_intersections.append(area)
	
func _on_area_exited(area):
	current_intersections.erase(area)
	
func _on_damage_taken():
	animation_tree.set("parameters/conditions/is_hit", true)
	print("is_hit")
	await get_tree().create_timer(0.25).timeout
	reset_animation()

func reset_animation():
	animation_tree.set("parameters/conditions/is_hit", false)

func is_hitting_damage_box():
	return len(current_intersections) > 0

func _physics_process(delta):
	if health_system.can_take_damage() and is_hitting_damage_box():
		health_system.take_damage()
