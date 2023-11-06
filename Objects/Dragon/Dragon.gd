class_name Dragon extends Node3D

var hp: int
var stage := 1
var current_state := ""
var new_state := "Idle"
var current_state_object: Node

func _ready():
	Game.dragon = self

func _physics_process(delta):
	if new_state != "":
		current_state = new_state
		new_state = ""
		current_state_object = get_node("States/" + current_state)
		current_state_object.effect_start()
	if current_state != null:
		current_state_object.effect_process(delta)
		if new_state == "":
			new_state = current_state_object.get_next_state()
	
func force_state_change(_new_state: String):
	new_state = _new_state
