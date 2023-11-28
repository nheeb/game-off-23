extends CanvasLayer

var player_health_system : HealthSystem
@export var heart_icon : Texture2D
@export var heart_scale : float = 0.15
@onready var dragon_health_bar := %DragonHealthBar

func _ready():
	Game.player_ui = self

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

func set_item_texture(texture:Texture2D,_scale:float=0.367) -> Sprite2D:
	%ItemIcon.texture = texture
	%ItemIcon.scale = Vector2.ONE * _scale
	return %ItemIcon
#
#func set_item_material(material:Material) -> Sprite2D:
#	%ItemIcon.material = material
#	return %ItemIcon

func set_item_cooldown(progress: float):
	%ItemIcon.material.set("shader_parameter/progress", progress)

func set_item_visible(visibility:bool=!(%Item.visible)) -> bool:
	%Item.visible = visibility
	return %Item.visible

func woop():
	%AnimationPlayer.play("ItemIconWoop")
