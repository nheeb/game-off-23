extends Node

@export var audio_player : AudioStreamPlayer
@export var play_dragonhealthbar_sound : bool = false
@export var loop : bool = true
@export var continue_music : bool = true

@export var playlist : Array
@export var scale_sound : Array

@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

@export var music_titlescreen : Array
@export var music_ethnic : Array
@export var music_anotherepic : Array
@export var music_thirdtrack : Array
@export var music_victory : Array

var current_track : :
	set(new_track):
		if (current_track != null):
			current_track = null
			audio_player.stop()
		current_track = new_track
		audio_player.stream = current_track
		audio_player.play(start_at)

func _ready():
	current_track = music_titlescreen.pick_random()
	playlist.append_array(music_ethnic)
	playlist.append_array(music_anotherepic)
	playlist.append_array(music_thirdtrack)
	set_volume(Music.MUSIC_BUS_ID,0.2) # .5 was way to loud for me
	set_volume(Music.SFX_BUS_ID,0.5)

@export var set_victory_screen : bool = false : 
	set(value):
		if (true):
			add_child(load("res://UI/VictoryScreen.tscn").instantiate())


func set_volume(bus_index:int,value:float) -> float: #range between 0 and 1
	var new_value : float
	if value > 1: new_value = 1		#Do NOT change !
	else: new_value = value			#Do NOT change !
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(new_value))
	return new_value

func play_scale_build_up_sound(count:int) -> void:
	if (!play_dragonhealthbar_sound): return
	if(count % 3 == 1): 
		%AudioStreamScale.stream = scale_sound.pick_random()
		%AudioStreamScale.play()
	if(count % 3 == 2):
		%AudioStreamScale2.stream = scale_sound.pick_random()
		%AudioStreamScale2.play()
	if(count % 3 == 0):
		%AudioStreamScale3.stream = scale_sound.pick_random()
		%AudioStreamScale3.play()

func _on_audio_stream_player_finished():
	start_at = 0
	if (loop):
		current_track = current_track
		return
	elif (continue_music):
		var new_track = playlist.pick_random()
		if (playlist.size() > 1):
			while (new_track == current_track):
				new_track = playlist.pick_random()
		current_track = new_track


func fade_out(duration:float,new_track=null,_start_at:float=0):
	var previous_volume = audio_player.volume_db
	var tween := get_tree().create_tween()
	tween.tween_property(audio_player,"volume_db", -80 ,duration)
	await tween.finished
	
	if (previous_volume > 0): previous_volume = 0 #volume should not be higher than 0dB
	audio_player.volume_db = previous_volume
	
	if (new_track != null):
		start_at = _start_at
		current_track = new_track
	else:
		audio_player.stop()

var start_at :float= 0
func start_track(new_track,_start_at:float=0):
	current_track = new_track
	start_at = _start_at

func play_cutscene_music():
	#fade_out(1.5,Music.music_ethnic[0],2)
	start_track(Music.music_ethnic[0])
	loop = false
