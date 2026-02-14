# rock.gd
# Repton Returns - Godot 4.6 Port
# Falling rock implementation — falls under gravity, crushes player/monsters
# Original: Rock.cs

class_name Rock
extends Fallable


var playing_snd: bool = false    # public bool PlayingSnd;


func _ready() -> void:
	# private void Start()
	init()
	stopped_falling.connect(_on_stopped_falling)


func _process(delta: float) -> void:
	# private new void Update()
	super._process(delta)

	check_fall()

	# Stop sound?
	if falling == false and playing_snd:
		# this.GetComponent<AudioSource>().Stop();
		playing_snd = false


func move(dir: Vector3) -> bool:
	# public override bool Move(Vector3 direction)
	# Called when pushed by the player (horizontal moves)
	# Falling moves go through Fallable._do_fall() which bypasses this

	if level == null:
		return false

	# Check if destination is empty
	var target_x: int = int(grid_position.x + dir.x)
	var target_y: int = int(grid_position.z + dir.z)
	var target_piece: String = level.get_map_p_xy(target_x, target_y)

	if target_piece != "0":
		return false  # Blocked

	# Update map data for the push
	_update_map_for_move(dir)

	# Ok, start the move...
	if super.move(dir) == false:
		return false

	# Play Rock Sound
	if !playing_snd:
		# this.GetComponent<AudioSource>().Play();
		playing_snd = true

	return true


func traverse() -> void:
	# public override void Traverse()
	pass  # Rocks are not traversable


func _on_stopped_falling() -> void:
	# Check for crush when rock lands
	if level == null:
		return

	# Check if player is at this position
	if level.game != null:
		var player = level.game.player
		if player != null and player.grid_position == grid_position:
			player.die()

	# Check if a monster is at this position
	var grid_x: int = int(grid_position.x)
	var grid_y: int = int(grid_position.z)
	var piece_at: String = level.get_map_p_xy(grid_x, grid_y)
	if piece_at == "m":
		_kill_monster_at(grid_x, grid_y)


func _kill_monster_at(x: int, y: int) -> void:
	var piece_id: int = level.map_detail[x][y]["id"]
	if piece_id >= 0 and piece_id < level.objects.size():
		var obj = level.objects[piece_id]
		if obj is Monster:
			obj.die()
