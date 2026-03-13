# spirit.gd
# Repton Returns - Godot 4.6 Port
# Wandering spirits that follow walls with CCW/CW turning logic
# Spirits kill the player on contact, turn into diamonds when entering a cage
# Original: Spirit.cs

class_name Spirit
extends Movable


var spirit_state: int = 1       # 0 = Seek (check direction), 1 = Moving

var on_piece: String = "0"      # public char OnPiece;  (what the spirit is standing on)
var last_on_piece: String = "0" # public char LastOnPiece;
var on_id: int = -1             # public int OnId;
var last_on_id: int = -1        # public int LastOnId;

var first_move: bool = true     # First move uses special direction logic

# Pieces spirits can move through
const PASSABLE: Array = ["0", "e", "c"]


func _ready() -> void:
	# Enemies must process after player and rocks
	process_priority = 100


func spirit_init(v_pos: Vector3) -> void:
	# public void Init(Vector3 vPos)
	piece_type = "p"   # PieceType = Level.Piece.Spirit;
	time_to_move = 0.45
	on_piece = "0"
	on_id = -1
	spirit_state = 1  # Start moving
	last_time = 1.0   # Initial delay
	grid_position = v_pos
	last_position = v_pos
	last_position_abs = _grid_to_world(v_pos)
	direction = Vector3(0, 0, -1)  # Default: grid up (decreasing grid_y)
	last_direction = direction
	first_move = true


func _process(delta: float) -> void:
	if level == null:
		return

	last_time -= delta

	if spirit_state == 1 and last_time <= 0.0:
		spirit_state = 0

	if spirit_state == 0:
		# Check gravity first (3D levels)
		if not _check_spirit_gravity():
			_control_seek()

	# Interpolate visual position
	_move_3d()


func move(dir: Vector3) -> bool:
	# Update local info
	spirit_state = 1

	last_position = grid_position
	last_position_abs = position
	last_direction = direction

	grid_position += dir
	direction = dir

	last_on_piece = on_piece
	last_on_id = on_id

	last_time = time_to_move

	if level == null:
		return true

	var new_pos: Vector3 = grid_position
	on_id = level.get_map_id_at(new_pos)
	on_piece = level.get_map_at(new_pos)

	# Does Repton die as a result of this move?
	if level.game != null and level.game.player != null:
		var player = level.game.player
		if player.grid_position == grid_position or player.grid_position == last_position:
			player.die()

	# Update map: restore old position
	level.set_map_at(last_position, last_on_piece)
	level.set_map_id_at(last_position, last_on_id)

	# Place spirit on map at new position
	level.set_map_at(new_pos, "p")

	# If we went into a cage, turn into a diamond
	if on_piece == "c":
		var cx := int(new_pos.x)
		var cy := int(new_pos.z)
		if level.has_player_gravity():
			# 3D: use y,z coords
			_enter_cage_3d(new_pos)
		else:
			_enter_cage(cx, cy)

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


func _moveable_to(v_pos: Vector3, v_dir: Vector3) -> bool:
	# Check if spirit can move to the piece at the given direction from position
	if level == null:
		return false

	var check_pos: Vector3 = v_pos + v_dir
	var piece: String = level.get_map_at(check_pos)

	return piece in PASSABLE or piece == "i"


func _control_seek() -> void:
	# Wall-following AI (left-hand rule / CCW preference)
	var can_move: bool = false
	var corn_try: int = 0

	while corn_try < 4 and not can_move:
		if first_move:
			# Determine starting direction
			# Default to grid up (-z)
			direction = Vector3(0, 0, -1)
			last_direction = direction

			# Try up, then right, then down, then left
			if not _moveable_to(grid_position, Vector3(0, 0, -1)):
				direction = Vector3.RIGHT
			if not _moveable_to(grid_position, Vector3.RIGHT):
				direction = Vector3(0, 0, 1)
			if not _moveable_to(grid_position, Vector3(0, 0, 1)):
				direction = Vector3.LEFT

			first_move = false
		else:
			# Is there a wall to the right (CCW of current dir) that we should hug?
			can_move = _moveable_to(grid_position, _turn_ccw(direction))

			if can_move:
				# No wall there! Turn CCW (hug wall left)
				direction = _turn_ccw(direction)

		# Can we move forward in current direction?
		can_move = _moveable_to(grid_position, direction)

		if can_move:
			move(direction)
		else:
			# Blocked — turn clockwise and try again
			direction = _turn_cw(direction)
			corn_try += 1


func _turn_cw(v_dir: Vector3) -> Vector3:
	# Clockwise: forward → right → back → left → forward
	if v_dir == Vector3(0, 0, 1):     # forward
		return Vector3.RIGHT
	elif v_dir == Vector3(0, 0, -1):  # back
		return Vector3.LEFT
	elif v_dir == Vector3.LEFT:
		return Vector3(0, 0, 1)       # forward
	elif v_dir == Vector3.RIGHT:
		return Vector3(0, 0, -1)      # back
	return v_dir


func _turn_ccw(v_dir: Vector3) -> Vector3:
	# Counter-clockwise: forward → left → back → right → forward
	if v_dir == Vector3(0, 0, 1):     # forward
		return Vector3.LEFT
	elif v_dir == Vector3(0, 0, -1):  # back
		return Vector3.RIGHT
	elif v_dir == Vector3.LEFT:
		return Vector3(0, 0, -1)      # back
	elif v_dir == Vector3.RIGHT:
		return Vector3(0, 0, 1)       # forward
	return v_dir


func _check_spirit_gravity() -> bool:
	# Check if spirit should fall (3D levels only)
	if level == null or not level.has_player_gravity():
		return false
	if last_time > 0.0:
		return false
	var below_pos: Vector3 = level.get_below(grid_position)
	var below_piece: String = level.get_map_at(below_pos)
	if below_piece == "0":
		move(level.get_gravity_dir())
		return true
	return false


func _enter_cage(x: int, y: int) -> void:
	# Spirit enters a cage — becomes a diamond (2D)
	level.set_map_at(Vector3(x, 0, y), "d")
	level.set_map_id_at(Vector3(x, 0, y), -1)

	# Replace the cage mesh with a diamond
	level.replace_piece(x, y, "d")

	level.spirits -= 1
	level.diamonds += 1

	queue_free()


func _enter_cage_3d(pos: Vector3) -> void:
	# Spirit enters a cage — becomes a diamond (3D)
	level.set_map_at(pos, "d")
	level.set_map_id_at(pos, -1)

	level.replace_piece_v(pos, "d")

	level.spirits -= 1
	level.diamonds += 1

	queue_free()
