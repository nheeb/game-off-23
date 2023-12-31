class_name PlayerDetectionArea extends Area3D

signal player_detected

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

func _ready():
	if has_node("VisualIndicator"):
		get_node("VisualIndicator").visible = active

func _physics_process(delta):
	if active:
		if perishable:
			lifetime -= delta
			if lifetime <= 0.0:
				self.active = false
				if delete_on_perish:
					queue_free()

func _on_area_entered(area):
	if active:
		player_detected.emit()
		if delete_on_player_hit:
			queue_free()

func activate(_lifetime := 0.0):
	self.active = true
	if perishable:
		if _lifetime == 0.0:
			lifetime = default_lifetime
		else:
			lifetime = _lifetime

