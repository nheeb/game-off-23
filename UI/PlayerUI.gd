extends CanvasLayer

var player_health_system : HealthSystem
@export var heart_icon : Texture2D
@export var heart_scale : float = 0.15
@onready var dragon_health_bar := %DragonHealthBar

func _ready():
	Game.player_ui = self
#	heart_icon.modulate# = "fb687e"

func _process(delta):
	if (player_health_system != null):
		update_health(null)

func update_health(_source) -> void:
	var health : float = player_health_system.health
	
	for h in %HBHealth.get_children(): 
		h.queue_free()
	
	for i in int(health):
		%HBHealth.add_child(create_heart())

func create_heart():
	var heart = TextureRect.new()
	heart.texture = heart_icon
#	heart.modulate = "fb687e"
#	heart.set_scale(Vector2(heart_scale,heart_scale))
	
#	heart.color = "fb687e"
	heart.custom_minimum_size.x = 50
	heart.custom_minimum_size.y = 50
	heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE

	return heart

func set_health_system(health_system:HealthSystem) -> void:
	player_health_system = health_system
	player_health_system.connect("damage_taken", update_health)

	var max_health : float = player_health_system.max_health
	for i in max_health:
		%HBHealth.add_child(create_heart())

func set_cutscene_tooltip_visible(_visible: bool):
	%CutsceneTooltip.visible = _visible
