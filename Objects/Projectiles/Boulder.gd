extends Node3D

const ATTACK_HINT_BALL = preload("res://Objects/Effects/AttackHintFallingDebris.tscn")
var roar_reference

func fall_down(target_pos: Vector3):
	var fall_time = .75 if Game.dragon.stage == 3 else 1.0
	var tween := get_tree().create_tween()
	tween.tween_property(self, "global_position", Functions.get_nearest_ground(target_pos), fall_time).from(target_pos + Vector3.UP * 20.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	var hint = ATTACK_HINT_BALL.instantiate()
	Game.world.add_child(hint)
	hint.size = 4
	hint.global_position = Functions.get_nearest_ground(target_pos)
	var hint_normal = Functions.get_nearest_ground_normal(target_pos)
	Functions.align_node(hint, Vector3.UP, hint_normal)
	tween.finished.connect(hint.queue_free)
	await tween.finished
	roar_reference.play_dawnfall_sound()
	$PlayerDamageArea.activate()
	Game.main_cam.screen_shake(.6)

var crushing := false
func crush():
	if crushing: return
	crushing = true
	$Model.queue_free()
	$GPUParticles3D.emitting = true
	get_tree().create_timer($GPUParticles3D.lifetime).timeout.connect(queue_free)

func _on_dragon_detection_body_entered(body):
	crush()

func _on_dragon_detection_area_entered(area):
	crush()

@export var uber := false
func _ready():
	if uber:
		get_tree().create_timer(.5).timeout
		crush()
