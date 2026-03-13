# rock.gd
# Repton Returns - Godot 4.6 Port
# Falling rock implementation — falls under gravity, crushes player/monsters
# Original: Rock.cs

class_name Rock
extends Fallable


var playing_snd: bool = false    # public bool PlayingSnd;
var _fall_audio: AudioStreamPlayer3D = null


func _ready() -> void:
	# private void Start()
	init()
	stopped_falling.connect(_on_stopped_falling)

	# Create 3D audio emitter for looping fall sound
	_fall_audio = AudioStreamPlayer3D.new()
	_fall_audio.stream = SFX.rock_fall
	_fall_audio.max_distance = 40.0
	_fall_audio.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
	_fall_audio.autoplay = false
	add_child(_fall_audio)


func _process(delta: float) -> void:
	# private new void Update()
	super._process(delta)

	check_fall()

	# Start/stop looping fall sound
	if falling and not playing_snd:
		_fall_audio.play()
		playing_snd = true
	elif not falling and playing_snd:
		_fall_audio.stop()
		playing_snd = false


func move(dir: Vector3) -> bool:
	# public override bool Move(Vector3 direction)
	# Called when pushed by the player (horizontal moves)
	# Falling moves go through Fallable._do_fall() which bypasses this

	if level == null:
		return false

	# Check if destination is empty
	var target_pos: Vector3 = grid_position + dir
	var target_piece: String = level.get_map_at(target_pos)

	if target_piece != "0" and target_piece != "m":
		return false  # Blocked

	# Kill monster at destination if present
	if target_piece == "m":
		_kill_monster_at_v(target_pos)

	# Update map data for the push
	_update_map_for_move(dir)

	# Ok, start the move...
	if super.move(dir) == false:
		return false

	return true


func traverse() -> void:
	# public override void Traverse()
	pass  # Rocks are not traversable


func _on_stopped_falling() -> void:
	# Play crash sound
	SFX.play_at(self, SFX.rock_crash)

	# Check for crush when rock lands
	if level == null:
		return

	# Check if player is at this position
	if level.game != null:
		var player = level.game.player
		if player != null and player.grid_position == grid_position:
			player.die()

	# Check if a monster is at this position
	_kill_monster_at_v(grid_position)


func _kill_monster_at_v(pos: Vector3) -> void:
	# Try map id lookup first
	var piece_id: int = level.get_map_id_at(pos)
	if piece_id >= 0 and piece_id < level.objects.size():
		var obj = level.objects[piece_id]
		if obj is Monster:
			obj.die()
			return
	# Fallback: scan all objects for a monster at this position
	for obj in level.objects:
		if obj != null and obj is Monster and obj.monster_state != Monster.State.DEAD:
			if int(obj.grid_position.x) == int(pos.x) \
					and int(obj.grid_position.y) == int(pos.y) \
					and int(obj.grid_position.z) == int(pos.z):
				obj.die()
				return
