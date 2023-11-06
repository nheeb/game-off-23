extends Control

var health = 100 : set=set_health
var stage = 1 : set = set_stage

func set_health(h):
	health = h
	$DragonHealthBar.health = h
	$health.text = str(h)

func set_stage(s):
	stage = s
	$DragonHealthBar.stage = s
	$stage.text = str(s)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage(amount):
	var h = health - amount
	if h <=0:
		h = 100
		stage += 1
	health = h

func _on_reset_pressed():
	stage = 1
	health = 100

func _on_health_text_changed():
	health = int($health.text)
