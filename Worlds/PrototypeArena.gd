extends Node3D

func _ready():
	Game.world = self
	Game.player_health_system.death.connect(defeat_animation)

func defeat_animation(_source):
	Game.dragon.force_state_change("Disrespect")
	await get_tree().create_timer(.4).timeout
	var tween := get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property($DirectionalLight3D, "light_energy", 0.0, 1.5)
	tween.tween_property($WorldEnvironment.environment, "ambient_light_sky_contribution", 0.0, 1.5)
	tween.tween_property($Player/LightForDeathAnimation, "light_energy", 10.0, 1.5)
	$Player/LightForDeathAnimation.visible = true
	await get_tree().create_timer(.8).timeout
	get_tree().call_group("fallen_scale", "start_contracting")
	await get_tree().create_timer(4).timeout
	Game.load_shop()
