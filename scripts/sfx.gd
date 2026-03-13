# sfx.gd
# Repton Returns - Godot 4.6 Port
# Sound effect helper — preloads all game sounds, provides play methods

class_name SFX
extends RefCounted


# Preloaded audio streams
static var diamond: AudioStream = preload("res://sounds/dimond.wav")
static var crown: AudioStream = preload("res://sounds/crown.wav")
static var key: AudioStream = preload("res://sounds/key.wav")
static var dig: AudioStream = preload("res://sounds/master dig.wav")
static var time_capsule: AudioStream = preload("res://sounds/time_cap.wav")
static var transporter: AudioStream = preload("res://sounds/transporter.wav")
static var rock_fall: AudioStream = preload("res://sounds/rock_fall.wav")
static var rock_crash: AudioStream = preload("res://sounds/rock_crash.wav")
static var egg_cracking: AudioStream = preload("res://sounds/egg_cracking.wav")
static var egg_crunch: AudioStream = preload("res://sounds/egg_crunch.wav")
static var monster_awake: AudioStream = preload("res://sounds/master monster_awake.wav")
static var monster_die: AudioStream = preload("res://sounds/master monster_die.wav")
static var spirit_near: AudioStream = preload("res://sounds/spirit_near.wav")
static var spirit_caught: AudioStream = preload("res://sounds/spirit_caught.wav")
static var bomb_explosion: AudioStream = preload("res://sounds/bomb_explosion.wav")
static var startup: AudioStream = preload("res://sounds/startup sound.wav")
static var level_trans: AudioStream = preload("res://sounds/level-trans.wav")
static var fungus: AudioStream = preload("res://sounds/fungus.wav")


static func play_at(parent: Node3D, stream: AudioStream) -> void:
	# Play a one-shot 3D sound at the parent's position, auto-frees when done
	var player := AudioStreamPlayer3D.new()
	player.stream = stream
	player.max_distance = 40.0
	player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
	parent.add_child(player)
	player.finished.connect(player.queue_free)
	player.play()


static func play_global(tree: SceneTree, stream: AudioStream) -> void:
	# Play a non-positional one-shot sound, auto-frees when done
	var player := AudioStreamPlayer.new()
	player.stream = stream
	tree.root.add_child(player)
	player.finished.connect(player.queue_free)
	player.play()
