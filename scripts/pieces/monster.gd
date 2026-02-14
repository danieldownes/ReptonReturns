# monster.gd
# Repton Returns - Godot 4.6 Port
# Enemy AI with states (InEgg, EggCracking, Waking, Seeking, Dead)
# Seeks player by moving one grid cell at a time toward Repton
# Original: Monster.cs

class_name Monster
extends Movable


enum State {
	IN_EGG = 0,       # InEgg = 0,
	EGG_CRACKING,     # EggCracking,
	WAKING,           # Waking,
	SEEKING,          # Seeking,
	DEAD              # Dead
}

var monster_state: int = State.WAKING   # public State iState;

var on_piece: String = "0"      # public char cOnPiece;  (what the monster is standing on)
var last_on_piece: String = "0" # public char cLastOnPiece;
var on_id: int = -1             # public int iOnId;
var last_on_id: int = -1        # public int iLastOnId;

var is_earth: bool = false      # bool bEarth = false;  (monster inside earth = protected from crush)

# Pieces monsters can move through
const PASSABLE: Array = ["0"]


func _ready() -> void:
	pass


func monster_init(v_pos: Vector3) -> void:
	# public void Init(Vector3 vPos)
	piece_type = "m"   # PieceType = Level.Piece.Monster;

	time_to_move = 0.45

	on_piece = "0"
	on_id = -1

	monster_state = State.WAKING
	last_time = 1.0  # 1 second waking delay

	grid_position = v_pos
	last_position = v_pos
	last_position_abs = _grid_to_world(v_pos)
	direction = Vector3(0, 0, 1)    # Facing down on grid (increasing grid_y)
	last_direction = Vector3(0, 0, 1)


func _process(delta: float) -> void:
	# private new void Update()

	if monster_state == State.DEAD:
		return

	if last_time > 0.0:
		last_time -= delta

	if monster_state == State.WAKING:
		if last_time <= 0.0:
			monster_state = State.SEEKING
	else:
		_control_seek()

	# Interpolate position (Monster has its own Move3D using AddSlant)
	_move_3d()


func move(dir: Vector3) -> bool:
	# public override bool Move(Vector3 directin)

	if level == null:
		return false

	# Store what we're leaving
	last_on_piece = on_piece
	last_on_id = on_id

	# Update map: restore what was under us at old position
	var old_x: int = int(grid_position.x)
	var old_y: int = int(grid_position.z)
	level.map_detail[old_x][old_y]["type_id"] = on_piece
	level.map_detail[old_x][old_y]["id"] = on_id

	# Call base move (updates grid_position, sets up animation timing)
	super.move(dir)

	# Record what's at the new position (before we overwrite it)
	var new_x: int = int(grid_position.x)
	var new_y: int = int(grid_position.z)
	on_piece = level.map_detail[new_x][new_y]["type_id"]
	on_id = level.map_detail[new_x][new_y]["id"]

	# Track if monster is inside earth
	is_earth = (on_piece == "e")

	# Place monster on map at new position
	var my_id: int = level.map_detail[old_x][old_y].get("_monster_obj_id", -1)
	# Find our object id from the old position backup or objects array
	level.map_detail[new_x][new_y]["type_id"] = "m"

	# Does Repton die as a result of this move?
	if level.game != null and level.game.player != null:
		var player = level.game.player
		if player.grid_position == grid_position or player.grid_position == last_position:
			player.die()

	return true


func _move_3d() -> void:
	# Interpolate visual position using AddSlant
	# Monster.cs uses game.loadedLevel.AddSlant() for both positions
	if last_time > 0.0 and level != null:
		var from_world: Vector3 = level.add_slant(last_position)
		var to_world: Vector3 = level.add_slant(grid_position)
		var t: float = (time_to_move - last_time) / time_to_move
		t = clampf(t, 0.0, 1.0)
		position = from_world.lerp(to_world, t)
	elif level != null:
		position = level.add_slant(grid_position)


func _control_seek() -> void:
	# void ControlSeek()

	if monster_state == State.EGG_CRACKING:
		# Egg cracking sequence handled by egg.gd
		pass

	elif monster_state == State.WAKING:
		# Has monster fully awakened?
		if last_time <= 0.0:
			monster_state = State.SEEKING

	elif monster_state == State.SEEKING:
		# Ready to move again?
		if last_time <= 0.0:
			if level == null or level.game == null or level.game.player == null:
				return

			last_direction = direction

			# Simply move towards Repton
			var player_pos: Vector3 = level.game.player.grid_position
			var to_repton: Vector3 = player_pos - grid_position
			var move_dir: Vector3 = Vector3.ZERO

			# Randomly pick X or Z axis (50/50) so no axis has preference
			if randi() % 2 == 0:
				if to_repton.x != 0.0:
					move_dir = Vector3.RIGHT if to_repton.x > 0 else Vector3.LEFT
			else:
				if to_repton.z != 0.0:
					# forward = (0,0,1) = grid up, back = (0,0,-1) = grid down
					move_dir = Vector3(0, 0, 1) if to_repton.z > 0 else Vector3(0, 0, -1)

			if move_dir == Vector3.ZERO:
				# Chosen axis had no difference, try the other
				if to_repton.x != 0.0:
					move_dir = Vector3.RIGHT if to_repton.x > 0 else Vector3.LEFT
				elif to_repton.z != 0.0:
					move_dir = Vector3(0, 0, 1) if to_repton.z > 0 else Vector3(0, 0, -1)

			if move_dir == Vector3.ZERO:
				return  # On top of player or no direction to move

			# Check if it is okay to move in this direction
			var target_pos: Vector3 = grid_position + move_dir
			var target_x: int = int(target_pos.x)
			var target_y: int = int(target_pos.z)
			var target_piece: String = level.get_map_p_xy(target_x, target_y)

			if target_piece in PASSABLE or target_piece == "i":
				move(move_dir)


func die() -> bool:
	# public bool Die()
	if !is_earth:
		_die_forced()
		return true
	else:
		return false


func _die_forced() -> void:
	# void DieForced()
	if level != null:
		level.monsters_alive -= 1
		# Clear from map
		var grid_x: int = int(grid_position.x)
		var grid_y: int = int(grid_position.z)
		level.map_detail[grid_x][grid_y]["type_id"] = "0"
		level.map_detail[grid_x][grid_y]["id"] = -1

	monster_state = State.DEAD
	queue_free()
