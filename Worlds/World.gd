class_name World extends Node3D

@onready var player_spawn_intro : Node3D = $PositionsForCutscene/PlayerSpawnIntro
@onready var player_spawn_battle : Node3D = $PositionsForCutscene/PlayerSpawnBattle
@onready var area_start_cutscene : Area3D = $PositionsForCutscene/AreaStartCutscene

func _ready():
	Game.world = self
	Game.player_health_system.death.connect(defeat_animation)
	if Game.current_game_state == Game.GAME_STATE.Intro:
		make_everything_ready_for_intro()
	elif Game.current_game_state == Game.GAME_STATE.Battle:
		make_everything_ready_for_battle()
	else:
		printerr("Wrong GameState when world is ready.")

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

func make_everything_ready_for_intro():
	area_start_cutscene.body_entered.connect(start_cutscene, CONNECT_ONE_SHOT)
	Game.player.global_position = player_spawn_intro.global_position
	Game.dragon.force_state_change("PreCutscene")

func make_everything_ready_for_battle():
	Game.player.global_position = player_spawn_battle.global_position
	Game.dragon.force_state_change("Idle")

var cutscene_running := false
func start_cutscene():
	cutscene_running = true
	Game.current_game_state = Game.GAME_STATE.Cutscene
	Game.dragon.force_state_change("Cutscene")
	# Disable player input
	# Camera to dragon
	# Whatever
	await get_tree().create_timer(10.0).timeout
	end_cutscene()

func end_cutscene():
	if cutscene_running:
		cutscene_running = false
		make_everything_ready_for_battle()

func _input(event):
	if cutscene_running:
		if event.is_action_pressed("skip_cutscene"):
			end_cutscene()