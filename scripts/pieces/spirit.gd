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
var _seeking_edge: bool = false  # 3D: moving right to find an edge to hug

# Pieces spirits can move through
const PASSABLE: Array = ["0", "e", "c", "p"]


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
	var dest_piece: String = level.get_map_at(new_pos)
	on_id = level.get_map_id_at(new_pos)

	# If another spirit is here, get the real underlying piece from that spirit
	if dest_piece == "p":
		on_piece = _get_spirit_on_piece_at(new_pos)
	else:
		on_piece = dest_piece

	# Does Repton die as a result of this move?
	if level.game != null and level.game.player != null:
		var player = level.game.player
		if player.grid_position == grid_position or player.grid_position == last_position:
			player.die()

	# Update map: restore old position
	# If another spirit is still at our old position, keep "p" on the map
	var old_map: String = level.get_map_at(last_position)
	if old_map == "p" and _has_other_spirit_at(last_position):
		pass  # Another spirit is there — don't overwrite
	else:
		level.set_map_at(last_position, last_on_piece)
		level.set_map_id_at(last_position, last_on_id)

	# Place spirit on map at new position
	level.set_map_at(new_pos, "p")

	# If we went into a cage, turn into a diamond
	if on_piece == "c":
		_enter_cage(new_pos)

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

	if not (piece in PASSABLE or piece == "i"):
		return false

	# In 3D levels, spirit can only move to supported positions (no falling/climbing)
	if level.has_player_gravity():
		var below: Vector3 = level.get_below(check_pos)
		var below_piece: String = level.get_map_at(below)
		if below_piece == "0":
			return false  # No ground — spirit can't go there

	return true


func _control_seek() -> void:
	# 3D seeking-edge mode: keep moving right until we find a wall or edge to hug
	if _seeking_edge:
		# Check if there's now something to hug (a blocked direction nearby)
		for test_dir in [Vector3(0, 0, -1), Vector3.RIGHT, Vector3(0, 0, 1), Vector3.LEFT]:
			if not _moveable_to(grid_position, test_dir):
				# Found a wall/edge — face so wall is to our left
				direction = _turn_ccw(test_dir)
				_seeking_edge = false
				break
		if _seeking_edge:
			# Still no edge — keep moving right
			if _moveable_to(grid_position, Vector3.RIGHT):
				move(Vector3.RIGHT)
			else:
				# Can't move right — stop seeking, fall through to wall-following
				_seeking_edge = false
			return

	# Wall-following AI (left-hand rule / CCW preference)
	var can_move: bool = false
	var corn_try: int = 0

	while corn_try < 4 and not can_move:
		if first_move:
			first_move = false
			if level != null and level.has_player_gravity():
				# 3D: check if we have something to hug (wall or edge nearby)
				var has_neighbour: bool = false
				for test_dir in [Vector3(0, 0, -1), Vector3.RIGHT, Vector3(0, 0, 1), Vector3.LEFT]:
					if not _moveable_to(grid_position, test_dir):
						# Found a wall/edge — face so wall is to our left
						direction = _turn_ccw(test_dir)
						has_neighbour = true
						break
				if not has_neighbour:
					# Open ground — move right until we find an edge
					_seeking_edge = true
					if _moveable_to(grid_position, Vector3.RIGHT):
						move(Vector3.RIGHT)
					return
			else:
				# 2D: original logic
				direction = Vector3(0, 0, -1)
				last_direction = direction
				if not _moveable_to(grid_position, Vector3(0, 0, -1)):
					direction = Vector3.RIGHT
				if not _moveable_to(grid_position, Vector3.RIGHT):
					direction = Vector3(0, 0, 1)
				if not _moveable_to(grid_position, Vector3(0, 0, 1)):
					direction = Vector3.LEFT
		else:
			# Hug-wall-left: check if wall to our left is still there
			# by testing CW (right) — if open, turn right into it
			can_move = _moveable_to(grid_position, _turn_cw(direction))

			if can_move:
				# Opening to the right — turn CW to keep wall on left
				direction = _turn_cw(direction)

		# Can we move forward in current direction?
		can_move = _moveable_to(grid_position, direction)

		if can_move:
			move(direction)
		else:
			# Blocked — turn CCW (left) and try again
			direction = _turn_ccw(direction)
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



func _has_other_spirit_at(pos: Vector3) -> bool:
	# Check if any other spirit is currently at this position
	if level == null:
		return false
	for obj in level.objects:
		if obj != null and obj is Spirit and obj != self:
			if obj.is_at_grid(pos):
				return true
	return false


func _get_spirit_on_piece_at(pos: Vector3) -> String:
	# Find another spirit at this position and return what's under it
	if level == null:
		return "0"
	for obj in level.objects:
		if obj != null and obj is Spirit and obj != self:
			if obj.is_at_grid(pos):
				return obj.on_piece
	return "0"


func _play_sound_on_level(stream: AudioStream) -> void:
	# Play sound parented to level so it survives queue_free
	var snd := AudioStreamPlayer3D.new()
	snd.stream = stream
	snd.max_distance = 40.0
	snd.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
	snd.position = position
	level.add_child(snd)
	snd.finished.connect(snd.queue_free)
	snd.play()


func _enter_cage(pos: Vector3) -> void:
	_play_sound_on_level(SFX.spirit_caught)

	# Restore the cage on the map first (spirit overwrote it with "p")
	level.set_map_at(pos, "c")

	# Replace cage mesh with diamond
	level.replace_piece_v(pos, "d")

	level.spirits -= 1
	# Don't increment diamonds — the cage was already counted as a diamond at load time

	# Remove spirit
	queue_free()
