class_name MagicCasting extends Node

var is_available = true

@onready var timer: Timer = $Timer
@onready var health_system: HealthSystem = $"../HealthSystem"
@export var bubble_mesh: MeshInstance3D
@export var magic_particles: GPUParticles3D

const PICKUP_CARROT = preload("res://Objects/Pickups/CarrotPickup.tscn")

func cast():
	if not is_available:
		return
	var spell = PlayerStats.active_spell
	if spell == PlayerStats.SPELL_TYPE.Water:
		cast_water()
	elif spell == PlayerStats.SPELL_TYPE.Carrot:
		cast_carrot()
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
	
func cast_carrot():
	magic_particles.emitting = true
	apply_cooldown(30)
	await get_tree().create_timer(0.5).timeout
	for i in range(1):
		var pos = Game.player.global_position \
		+ Vector3(randf() * 10 - 5, 0.0, randf() * 10 - 5)
		pos = Functions.get_nearest_ground(pos) + Vector3.UP
		var pickup: CarrotPickup = PICKUP_CARROT.instantiate()
		get_tree().get_root().add_child(pickup)
		print(pickup)
		print(pickup.position)
		print(pos)
		pickup.transform = Transform3D(Basis(), pos)

func _on_cooldown_reset():
	is_available = true
	timer.stop()
