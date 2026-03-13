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
var object_id: int = -1         # Index in level.objects array

# Pieces monsters can move through
const PASSABLE: Array = ["0"]


func _ready() -> void:
	# Monsters must process after player and rocks so pushes resolve first
	process_priority = 100


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

	# Read our object id from the map (set by level during loading)
	if level != null:
		object_id = level.get_map_id_at(v_pos)


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
		# Check gravity first (3D levels)
		if not _check_monster_gravity():
			# Monster can only seek if it has ground support
			if level != null and level.has_player_gravity():
				var below_pos: Vector3 = level.get_below(grid_position)
				var below_piece: String = level.get_map_at(below_pos)
				if below_piece == "0":
					return  # No ground under monster — can't move
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
	var old_pos: Vector3 = grid_position
	level.set_map_at(old_pos, on_piece)
	level.set_map_id_at(old_pos, on_id)

	# Call base move (updates grid_position, sets up animation timing)
	super.move(dir)

	# Record what's at the new position (before we overwrite it)
	var new_pos: Vector3 = grid_position
	on_piece = level.get_map_at(new_pos)
	on_id = level.get_map_id_at(new_pos)

	# Track if monster is inside earth
	is_earth = (on_piece == "e")

	# Place monster on map at new position
	level.set_map_at(new_pos, "m")
	level.set_map_id_at(new_pos, object_id)

	# Does Repton die as a result of this move?
	if monster_state != State.DEAD and level.game != null and level.game.player != null:
		var player = level.game.player
		if player.grid_position == grid_position or player.grid_position == last_position:
			player.die()

	return true


func _move_3d() -> void:
	# Interpolate visual position
	if last_time > 0.0 and level != null:
		var from_world: Vector3 = level.grid_to_world_v(last_position)
		var to_world: Vector3 = level.grid_to_world_v(grid_position)
		var t: float = (time_to_move - last_time) / time_to_move
		t = clampf(t, 0.0, 1.0)
		position = from_world.lerp(to_world, t)
	elif level != null:
		position = level.grid_to_world_v(grid_position)


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
			var target_piece: String = level.get_map_at(target_pos)

			if target_piece in PASSABLE or target_piece == "i":
				# In 3D levels, don't move to unsupported positions
				if level.has_player_gravity() and not _has_support_at(target_pos):
					return
				move(move_dir)


func _check_monster_gravity() -> bool:
	# Check if monster should fall (3D levels only)
	# Monster can only fall 1 block — must have support below
	if level == null or not level.has_player_gravity():
		return false
	if last_time > 0.0:
		return false
	var below_pos: Vector3 = level.get_below(grid_position)
	var below_piece: String = level.get_map_at(below_pos)
	if below_piece == "0":
		# Check there is support 1 block down (2 below current)
		var two_below: Vector3 = level.get_below(below_pos)
		var two_below_piece: String = level.get_map_at(two_below)
		if two_below_piece != "0":
			move(level.get_gravity_dir())
			return true
		# No support — monster stays put
	return false


func _has_support_at(target_pos: Vector3) -> bool:
	# Check if a position has ground support within a 1-block fall
	var below: Vector3 = level.get_below(target_pos)
	var below_piece: String = level.get_map_at(below)
	if below_piece != "0":
		return true
	var two_below: Vector3 = level.get_below(below)
	var two_below_piece: String = level.get_map_at(two_below)
	return two_below_piece != "0"


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
		# Clear from map — restore what was under us
		level.set_map_at(grid_position, on_piece)
		level.set_map_id_at(grid_position, on_id)
		# If mid-move, also clear the old position
		if last_position != grid_position:
			var old_piece: String = level.get_map_at(last_position)
			if old_piece == "m":
				level.set_map_at(last_position, "0")
				level.set_map_id_at(last_position, -1)

	monster_state = State.DEAD
	queue_free()
