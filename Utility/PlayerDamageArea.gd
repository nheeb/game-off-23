class_name PlayerDamageArea extends Area3D

@export var damage := 0
@export var knockback_force := 0.0
@export var active := false:
	set(value):
		active = value
		if has_node("VisualIndicator"):
			get_node("VisualIndicator").visible = value
@export var perishable := true
@export var lifetime := 0.0
@export var default_lifetime := .3
@export var delete_on_perish := false
@export var delete_on_player_hit := false
@export var cooldown_on_hit := .15

@onready var knockback_origin : Node3D = $KnockbackOrigin

func _ready():
	if has_node("VisualIndicator"):
		get_node("VisualIndicator").visible = active

func _physics_process(delta):
	if active and $Timer.is_stopped():
		if perishable:
			lifetime -= delta
			if lifetime <= 0.0:
				self.active = false
				if delete_on_perish:
					queue_free()
		if has_overlapping_areas():
			do_damage()
			if delete_on_player_hit:
				queue_free()

func activate(_lifetime := 0.0):
	self.active = true
	if perishable:
		if _lifetime == 0.0:
			lifetime = default_lifetime
		else:
			lifetime = _lifetime

func do_damage():
	if cooldown_on_hit > 0.0:
		$Timer.start(cooldown_on_hit)
	var health_system = Game.player.get_health_system()
	var player_motion = Game.player.get_motion()
	if health_system.can_take_damage():
		health_system.take_damage(self, damage)
		var knockback = (Game.player.global_position - knockback_origin.global_position).normalized() * knockback_force
		knockback.y = 0
		player_motion.apply_knockback(knockback)
		
