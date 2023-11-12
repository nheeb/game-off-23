extends Area3D

@onready var player: Player = $".."
@onready var health_system: HealthSystem = $"../Behaviours/HealthSystem"
@onready var player_motion: PlayerMotion = $"../Behaviours/PlayerMotion"
@onready var animation_tree: AnimationTree = $"../animations"

func _ready():
	health_system.connect("damage_taken", _on_damage_taken)
	health_system.connect("death", _on_death)
	
func _on_damage_taken(source: Node3D):
	animation_tree.set("parameters/conditions/is_hit", true)
	var knockback = (player.global_position - source.global_position).normalized() * 10.0
	knockback.y = 0
	player_motion.apply_knockback(knockback)
	await get_tree().create_timer(0.25).timeout
	reset_animation()
	
func _on_death(_source):
	animation_tree.set("parameters/conditions/is_dead", true)

func reset_animation():
	animation_tree.set("parameters/conditions/is_hit", false)

