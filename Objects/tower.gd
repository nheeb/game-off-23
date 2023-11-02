extends CSGBox3D

var active_until = 0
var active_duration = 0.05
var attack = load('res://Objects/Attack.tscn')
@export var note_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if note_index == 1:
		find_parent('level').note1.connect(hear)
	elif note_index == 2:
		find_parent('level').note2.connect(hear)
	elif note_index == 3:
		find_parent('level').note3.connect(hear)
	elif note_index == 4:
		find_parent('level').note4.connect(hear)

func hear():
	active_until = active_duration
	add_child(attack.instantiate())
	for area in get_node('Area3D').get_overlapping_areas():
		area.get_parent().damage()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active_until > 0:
		material.albedo_color = ['white', 'red', 'blue', 'green', 'orange'][note_index]
	else:
		material.albedo_color = ['black', 'yellow', 'cyan', 'lightgreen', 'gold'][note_index]
	active_until -= delta
