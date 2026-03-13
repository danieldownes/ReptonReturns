# music.gd
# Repton Returns - Godot 4.6 Port
# Background music manager — plays random tracks, loops when finished

class_name Music
extends AudioStreamPlayer


var _tracks: Array[AudioStream] = [
	preload("res://music/Meed.mp3"),
	preload("res://music/MeedB2.mp3"),
	preload("res://music/Ode.mp3"),
	preload("res://music/Persistence.mp3"),
	preload("res://music/The Thunderous Intro for Repton Returns.mp3"),
]


func _ready() -> void:
	volume_db = -6.0
	finished.connect(_on_finished)


func play_random() -> void:
	stream = _tracks[randi() % _tracks.size()]
	play()


func _on_finished() -> void:
	play_random()
