extends Node

@export var audio_player : AudioStreamPlayer
@export var loop : bool = true
@export var continue_music : bool = true

@export var playlist : Array

@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

var current_track : :
	set(new_track):
		if (current_track != null):
			audio_player.stop()
			current_track = null
		current_track = new_track
		audio_player.stream = current_track
		audio_player.play()

func _ready():
	current_track = playlist.pick_random()
	set_volume(Music.MUSIC_BUS_ID,0.5)
	set_volume(Music.SFX_BUS_ID,0.5)

@export var debug_fade_out : bool = false : 
	set(value):
		if (true):
			fade_out(4, playlist.pick_random())


func set_volume(bus_index:int,value:float) -> float: #range between 0 and 1
	var new_value : float
	if value > 1: new_value = 1		#Do NOT change !
	else: new_value = value			#Do NOT change !
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(new_value))
	return new_value


func _on_audio_stream_player_finished():
	if (loop):
		current_track = current_track
		return
	elif (continue_music):
		var new_track = playlist.pick_random()
		if (playlist.size() > 1):
			while (new_track == current_track):
				new_track = playlist.pick_random()
		current_track = new_track


func fade_out(duration:float,new_track=null):
	var previous_volume = AudioServer.get_bus_volume_db(MUSIC_BUS_ID)
	var tween := get_tree().create_tween()
	tween.tween_property(audio_player,"volume_db", -80 ,duration)
	await tween.finished
	
	if (previous_volume > 0): previous_volume = 0 #volume should not be higher than 0dB
	audio_player.volume_db = previous_volume
	
	if (new_track != null):
		current_track = new_track

func start_track(new_track):
	current_track = new_track
