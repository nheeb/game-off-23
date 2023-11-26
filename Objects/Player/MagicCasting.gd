class_name MagicCasting extends Node

var is_available = true

@onready var timer: Timer = $Timer
@onready var health_system: HealthSystem = $"../HealthSystem"
@export var bubble_mesh: MeshInstance3D
@export var magic_particles: GPUParticles3D

func cast():
	if not is_available:
		return
	var spell = PlayerStats.active_spell
	if spell == PlayerStats.SPELL_TYPE.Water:
		cast_water()
	elif spell == PlayerStats.SPELL_TYPE.None:
		pass
		
func apply_cooldown(amount: float):
	is_available = false
	timer.wait_time = amount
	timer.start()

func cast_water():
	magic_particles.emitting = true
	apply_cooldown(30)
	await get_tree().create_timer(0.5).timeout
	bubble_mesh.visible = true
	health_system.armour = 1
	await get_tree().create_timer(2.5).timeout
	bubble_mesh.visible = false
	health_system.armour = 0
	

func _on_cooldown_reset():
	is_available = true
	timer.stop()
