class_name EatingSystem extends Node

var progress = 0

@onready var health_system: HealthSystem = $"../HealthSystem"

func eat():
	progress += 1
	Game.player_ui.set_carrot(progress)
	if progress >= PlayerStats.carrots_per_health:
		progress -= PlayerStats.carrots_per_health
		health_system.heal(1)
