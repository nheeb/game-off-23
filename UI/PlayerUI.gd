extends Control


var player_health_system : HealthSystem

func _ready():
	Game.player_ui = self


func _process(delta):
	if (player_health_system != null):
		update_health()


func update_health() -> void:
	var health : float = player_health_system.health
	
	for h in %HBHealth.get_children(): 
		h.queue_free()
	
	for i in int(health):
		%HBHealth.add_child(create_heart())
	
	

func create_heart() -> ColorRect:
	var heart = ColorRect.new()
	heart.color = "fb687e"
	heart.custom_minimum_size.x = 50
	heart.custom_minimum_size.y = 50
	return heart

func set_health_system(health_system:HealthSystem) -> void:
	player_health_system = health_system
	player_health_system.connect("damage_taken", update_health)

	var max_health : float = player_health_system.max_health
	for i in max_health:
		%HBHealth.add_child(create_heart())
	
