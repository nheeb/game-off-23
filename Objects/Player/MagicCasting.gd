class_name MagicCasting extends Node

var is_available = true

@onready var timer: Timer = $Timer
@onready var health_system: HealthSystem = $"../HealthSystem"
@export var bubble_mesh: MeshInstance3D
@export var magic_particles: GPUParticles3D

const PICKUP_CARROT = preload("res://Objects/Pickups/CarrotPickup.tscn")
const SPELLBOOK_EFFECT = preload("res://Objects/Effects/SpellbookEffect.tscn")

func cast():
	if not is_available:
		return
	var spell = PlayerStats.active_spell
	if spell == PlayerStats.SPELL_TYPE.Water:
		cast_water()
	elif spell == PlayerStats.SPELL_TYPE.Carrot:
		cast_carrot()
	elif spell == PlayerStats.SPELL_TYPE.Ice:
		cast_ice()
	elif spell == PlayerStats.SPELL_TYPE.None:
		pass

var last_applied_cooldown : float
func apply_cooldown(amount: float):
	last_applied_cooldown = amount
	is_available = false
	timer.wait_time = amount
	timer.start()

func cast_water():
	apply_cooldown(25)
	
	var book = SPELLBOOK_EFFECT.instantiate()
	book.set_color(Color.ROYAL_BLUE)
	Game.world.add_child(book)
	await book.spell_cast
	
	magic_particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	bubble_mesh.visible = true
	health_system.armour = 1
	await get_tree().create_timer(2.5).timeout
	bubble_mesh.visible = false
	health_system.armour = 0
	
func cast_carrot():
	apply_cooldown(25)
	
	var book = SPELLBOOK_EFFECT.instantiate()
	book.set_color(Color.ORANGE)
	Game.world.add_child(book)
	await book.spell_cast
	
	magic_particles.emitting = true
	await get_tree().create_timer(0.5).timeout
	for i in range(3):
		var pos = Game.player.global_position \
		+ Vector3(randf() * 10 - 5, 0.0, randf() * 10 - 5)
		pos = Functions.get_nearest_ground(pos) + Vector3.UP
		var pickup: CarrotPickup = PICKUP_CARROT.instantiate()
		get_tree().get_root().add_child(pickup)
		pickup.transform = Transform3D(Basis(), pos)
	
func cast_ice():
	apply_cooldown(25)
	
	var book = SPELLBOOK_EFFECT.instantiate()
	book.set_color(Color.WHITE)
	Game.world.add_child(book)
	await book.spell_cast
	
	magic_particles.emitting = true
	Game.dragon.force_state_change("Freeze")


func _on_cooldown_reset():
	is_available = true
	timer.stop()
	Game.player_ui.woop()

func _physics_process(delta):
	if not timer.is_stopped():
		Game.player_ui.set_item_cooldown(1.0 - (timer.time_left / last_applied_cooldown))
