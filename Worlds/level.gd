extends Node3D

var a1
var t1
var t1_index = 0
var a2
var t2
var t2_index = 0
var a3
var t3
var t3_index = 0
var a4
var t4
var t4_index = 0

var time_passed = 0
var enemy_spawn_delay = 1.5
var enemy_spawn_jitter = 0.75
var next_enemy = 0
signal note1
signal note2
signal note3
signal note4
var rng = RandomNumberGenerator.new()
var base
var current_stage = 1
var selected_tower = null
var map_size = 10 : set = set_map_size

var playing = false

func set_map_size(mapsize):
	map_size = mapsize
	get_node('Camera3D').transform.origin.y = mapsize
	get_node('land').scale = Vector3(mapsize, mapsize, mapsize)

# Called when the node enters the scene tree for the first time.
func _ready():
	base = get_node('base')
	a1 = get_node("a1")
	a1.stream = load("res://Assets/Sounds/1.mp3")
	a2 = get_node("a2")
	a2.stream = load("res://Assets/Sounds/2.mp3")
	a3 = get_node("a3")
	a3.stream = load("res://Assets/Sounds/3.mp3")
	a4 = get_node("a4")
	a4.stream = load("res://Assets/Sounds/4.mp3")
	t1 = load_timing('res://Assets/Sounds/1.timing.txt')
	t2 = load_timing('res://Assets/Sounds/2.timing.txt')
	t3 = load_timing('res://Assets/Sounds/3.timing.txt')
	t4 = load_timing('res://Assets/Sounds/4.timing.txt')

func start_stage(stage):
	a1.play()
	if stage > 1:
		a2.play()
	if stage > 2:
		a3.play()
	if stage > 3:
		a4.play()
	t1_index = 0
	t2_index = 0
	t3_index = 0
	t4_index = 0
	time_passed = 0
	playing = true
	get_node('Control').hide()
	
func load_timing(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var timing = []
	for line in content.split('\n'):
		if len(line.strip_edges())>0:
			timing.append(float(line))
	return timing

func mouse_position():
	var position2D = get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 0)
	var position3D = dropPlane.intersects_ray(
		 get_node('Camera3D').project_ray_origin(position2D),
		 get_node('Camera3D').project_ray_normal(position2D)
	)
	return position3D

func _process(delta):
	if selected_tower!= null:
		var m = mouse_position()
		m.y = selected_tower.transform.origin.y
		m.x = floor(m.x/(current_stage*current_stage))*(current_stage*current_stage)
		m.z = floor(m.z/(current_stage*current_stage))*(current_stage*current_stage)
		selected_tower.transform.origin = m
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			selected_tower = null
	var debug_early_exit = Input.is_key_pressed(KEY_Q)
	if playing and (t1_index >= len(t1) or debug_early_exit):
		playing = false
		get_node('Control').show()
		current_stage += 1
		map_size = current_stage*current_stage*10
		get_node('wave_timer').text = ''
		a1.stop()
		a2.stop()
		a3.stop()
		a4.stop()
	if playing:
		next_enemy = max(0, next_enemy - delta)
		if next_enemy == 0:
			var enemy_type = rng.randi_range(1, current_stage)
			var e = load('res://Objects/enemy'+str(enemy_type)+'.tscn').instantiate()
			add_child(e)
			var angle = rng.randf_range(0,365)
			e.transform.origin.x = cos(deg_to_rad(angle))*map_size
			e.transform.origin.z = sin(deg_to_rad(angle))*map_size
			next_enemy = enemy_spawn_delay + rng.randf_range(-enemy_spawn_jitter, enemy_spawn_jitter)
		if t1[t1_index] <= delta+time_passed:
			t1_index+=1
			note1.emit()
		if t2[t2_index] <= delta+time_passed:
			t2_index+=1
			note2.emit()
		if t3[t3_index] <= delta+time_passed:
			t3_index+=1
			note3.emit()
		if t4[t4_index] <= delta+time_passed:
			t4_index+=1
			note4.emit()
		
		time_passed += delta
		get_node('wave_timer').text = str(floor(t1[len(t1)-1])-floor(time_passed))


func _start_wave():
	start_stage(current_stage)


func _add_tower():
	selected_tower = load('res://Objects/tower'+str(current_stage)+'.tscn').instantiate()
	get_node('Towers').add_child(selected_tower)
