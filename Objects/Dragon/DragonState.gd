class_name DragonState extends Node

# Onready vars
@onready var state_name : String = self.name
@onready var dragon : Dragon = get_parent().get_parent()

# Probability Tags
@export var air_state := false
@export var natural_state := true
@export var stage_flags := [true, true, true]
@export var repeat_malus := true
@export var repeat_malus_ease_curve := 1.4
@export var repeat_malus_range := 4

func get_probabilty_modifier_from_tags() -> float:
	var modifier := 1.0
	modifier *= float(air_state == dragon.is_flying)
	modifier *= float(stage_flags[dragon.stage-1])
	if repeat_malus:
		modifier *= ease(dragon.get_state_history_index(state_name) + 1 / float(repeat_malus_range), repeat_malus_ease_curve)
	return modifier

func get_probability() -> float:
	return 0.0

func effect_start(index : int):
	pass

func effect_process(delta : float):
	pass

var next_state : String = ""
func get_next_state() -> String:
	var value := next_state
	next_state = ""
	return value

var counter : int = 0
var current_index : int
func set_active() -> int:
	if state_name != "Idle": dragon.state_history.append(state_name)
	counter += 1
	current_index = counter
	return current_index

func is_active(index : int = -1):
	if index == -1:
		return dragon.current_state_object == self
	else:
		return dragon.current_state_object == self and index == current_index

