class_name World extends Node3D

@onready var player_spawn_intro : Node3D = $PositionsForCutscene/PlayerSpawnIntro
@onready var player_spawn_battle : Node3D = $PositionsForCutscene/PlayerSpawnBattle
@onready var area_start_cutscene : Area3D = $PositionsForCutscene/AreaStartCutscene
@onready var cutscene: Node3D = $PositionsForCutscene/IntroCutScene

signal everything_ready

func _ready():
	Game.world = self
	Game.player_health_system.death.connect(defeat_animation)
	if Game.start_game_with_state == Game.GAME_STATE.Intro:
		make_everything_ready_for_intro()
	elif Game.start_game_with_state == Game.GAME_STATE.Battle:
		make_everything_ready_for_battle()
	else:
		printerr("Wrong GameState start when world is ready.")
	everything_ready.connect(func (): BlackScreen.fade_out(), CONNECT_ONE_SHOT)

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
	await get_tree().physics_frame
	var all_scales = get_tree().get_nodes_in_group("fallen_scale")
	all_scales.sort_custom(func (a, b): return Game.player.global_position.distance_squared_to(a.global_position) > Game.player.global_position.distance_squared_to(b.global_position))
	if all_scales.size() > 0:
		await all_scales[0].tree_exited
	await get_tree().create_timer(1).timeout
	# Fade black screen
	Game.load_shop()

func make_everything_ready_for_intro():
	area_start_cutscene.body_entered.connect(func (x): start_cutscene(), CONNECT_ONE_SHOT)
	Game.player.global_position = player_spawn_intro.global_position
	Game.dragon.force_state_change("PreCutscene")
	await get_tree().create_timer(3.0).timeout
	Game.current_game_state = Game.GAME_STATE.Intro
	everything_ready.emit()

func make_everything_ready_for_battle():
	if has_node("EntranceBlockage"):
		$EntranceBlockage.visible = true
		$EntranceBlockage/StaticBody3D/CollisionShape3D.disabled = false
	Game.dragon.force_state_change("PreCutscene")
	Game.player.global_position = player_spawn_battle.global_position
	if Game.current_game_state == Game.GAME_STATE.Loading:
		await get_tree().create_timer(3.0).timeout
	Game.current_game_state = Game.GAME_STATE.Battle
	Game.dragon.force_state_change("Idle")
	everything_ready.emit()

var cutscene_running := false
var cutscene_tooltip := false
func start_cutscene():
	var player_cam = get_viewport().get_camera_3d()
	cutscene_running = true
	Game.current_game_state = Game.GAME_STATE.Cutscene
	Game.dragon.force_state_change("Cutscene")
	# Disable player input
	cutscene.activate()
	await Signal(cutscene, 'completed')
	player_cam.current = true
	end_cutscene()

func end_cutscene():
	print("asdf")
	if cutscene_running:
		cutscene_running = false
		cutscene_tooltip = false
		PlayerUI.set_cutscene_tooltip_visible(false)
		make_everything_ready_for_battle()

func _input(event):
	if cutscene_running:
		if event.is_action_pressed("skip_cutscene"):
			if cutscene_tooltip:
				cutscene.deactivate()
			else:
				cutscene_tooltip = true
				PlayerUI.set_cutscene_tooltip_visible(true)
