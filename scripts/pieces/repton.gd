# repton.gd
# Repton Returns - Godot 4.6 Port
# Player character controller with movement, states, and inventory
# Original: Player.cs

class_name Repton
extends Movable


#var view: PlayerView    # public PlayerView view;

enum State {
	STOPPED = 0,     # Stoped = 0,
	WALK = 1,        # Walk = 1,
	PUSH = 2,        # Push = 2,
	PUSH_NO_WALK = 3,# PushNoWalk = 3,
	DIG_AND_WALK = 4,# DigAndWalk = 4,
	BOARD = 5        # Board = 5
}

var start_pos: Vector3           # public Vector3 StartPos;
var respawn_pos: Vector3         # Last safe respawn point (start or transporter dest)
var player_state: int = State.STOPPED  # public State PlayerState;
var old_state: int = State.STOPPED     # private State OldState;

var can_move: bool = true        # public bool CanMove = true;
var lives: int = 3               # public int Lives;
var want_move_me: int = 0        # private int WantMoveMe;

var inventory: Array[String] = []  # public List<string> Inventory = new List<string>();
var is_falling: bool = false  # True when player is falling due to gravity (3D levels)

# Input buffer for shuffle moves — allows queuing next move slightly early
var _buffered_dirs: Array = []
const INPUT_BUFFER_WINDOW: float = 0.08  # seconds before move ends to accept next input

# Facing direction (tween rotation)
var _mesh_node: Node3D = null
var _face_tween: Tween = null
const TURN_DURATION: float = 0.15

# Piece types that block movement (walls, barriers, filled walls, etc)
const WALL_PIECES: Array = ["5", "1", "2", "3", "4", "6", "7", "8", "9", "%", "&", "(", "!", "a", "s"]
# Piece types that are traversable (removed when player enters)
const TRAVERSABLE_PIECES: Array = ["e", "d", "k", "s", "t", "z", "x", "C"]
# Piece types that kill the player
const DEADLY_PIECES: Array = ["u", "f"]


func _ready() -> void:
	# private void Start()
	lives = 3
	player_state = State.STOPPED
	last_time = 0.0
	time_to_move = 0.3
	# Process before fallables so Repton can push rocks before they chain-fall
	process_priority = -2000

	# Register input actions
	_setup_input_actions()

	# Find mesh node for facing tween (deferred so child nodes are ready)
	_find_mesh_node.call_deferred()


func _find_mesh_node() -> void:
	_mesh_node = get_node_or_null("Mesh")


func _setup_input_actions() -> void:
	_add_action("move_left", [KEY_A, KEY_LEFT])
	_add_action("move_right", [KEY_D, KEY_RIGHT])
	_add_action("move_forward", [KEY_W, KEY_UP])
	_add_action("move_back", [KEY_S, KEY_DOWN])


func _add_action(action_name: String, keys: Array) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	for key in keys:
		var event := InputEventKey.new()
		event.physical_keycode = key
		InputMap.action_add_event(action_name, event)


func _process(delta: float) -> void:
	# Handle movement interpolation (from Movable base)
	if last_time > 0.0:
		# Buffer input near the end of the current move (enables shuffle)
		if last_time <= INPUT_BUFFER_WINDOW:
			_buffered_dirs = _read_input_dirs()
		_do_move(delta)
		return  # Don't accept input while moving

	# Movement complete - update state
	if player_state == State.WALK or player_state == State.PUSH or player_state == State.DIG_AND_WALK:
		old_state = player_state
		player_state = State.STOPPED

	# Check gravity (3D levels — player falls when unsupported)
	if level != null and level.has_player_gravity() and _check_player_gravity():
		return  # Falling — don't accept input

	# Execute buffered input or read fresh input
	# Try each pressed direction — if one is blocked, try the next
	if player_state == State.STOPPED or player_state == State.PUSH_NO_WALK:
		var dirs: Array = _buffered_dirs if not _buffered_dirs.is_empty() else _read_input_dirs()
		_buffered_dirs = []
		for dir in dirs:
			if try_move(dir):
				break

	# Was pushing (continuously), and now stopped?
	if old_state == State.PUSH and player_state != State.PUSH:
		pass  # Stop pushing sound

	if want_move_me > 0:
		want_move_me -= 1


func _read_input_dirs() -> Array:
	# Returns all currently pressed directions (ordered by priority)
	var dirs: Array = []
	if Input.is_action_pressed("move_left"):
		dirs.append(Vector3.LEFT)
	if Input.is_action_pressed("move_right"):
		dirs.append(Vector3.RIGHT)
	if Input.is_action_pressed("move_forward"):
		dirs.append(Vector3(0, 0, -1))
	if Input.is_action_pressed("move_back"):
		dirs.append(Vector3(0, 0, 1))
	return dirs


func try_move(dir: Vector3) -> bool:
	if level == null:
		return false

	var target_grid: Vector3 = grid_position + dir
	var target_piece: String = level.get_map_at(target_grid)

	# Wall or barrier? Can't move — unless it's a 1-high step in 3D levels
	if target_piece in WALL_PIECES:
		if level.has_player_gravity():
			var climb_grid: Vector3 = target_grid + Vector3(0, 1, 0)
			var climb_piece: String = level.get_map_at(climb_grid)
			var above_grid: Vector3 = grid_position + Vector3(0, 1, 0)
			var above_piece: String = level.get_map_at(above_grid)
			var climb_ok: bool = (climb_piece == "0" or climb_piece in TRAVERSABLE_PIECES)
			var above_ok: bool = (above_piece == "0" or above_piece in TRAVERSABLE_PIECES)
			if climb_ok and above_ok:
				if above_piece in TRAVERSABLE_PIECES:
					_collect_piece(above_grid, above_piece)
				if climb_piece in TRAVERSABLE_PIECES:
					_collect_piece(climb_grid, climb_piece)
				player_state = State.WALK
				_face_direction(dir)
				move(dir + Vector3(0, 1, 0))
				return true
		return false

	# Deadly piece? Player dies
	if target_piece in DEADLY_PIECES:
		die()
		return true

	# Bomb? Only traversable when all objectives complete
	if target_piece == "b":
		if level.diamonds <= 0 and level.crowns <= 0 and level.eggs <= 0 and level.monsters_alive <= 0 and level.spirits <= 0:
			level.remove_piece_v(target_grid)
			level.set_map_at(target_grid, "0")
			player_state = State.WALK
			_do_grid_move(dir)
			SFX.play_at(self, SFX.bomb_explosion)
			if level.game != null:
				level.game.level_complete()
			return true
		return false

	# Cage? Can't enter directly
	if target_piece == "c":
		return false

	# Monster? Player dies on contact
	if target_piece == "m":
		die()
		return true

	# Spirit? Player dies on contact
	if target_piece == "p":
		die()
		return true

	# Rock or Egg? Try to push
	if target_piece == "r" or target_piece == "g":
		var gravity_dir: Vector3 = level.get_gravity_dir()
		if dir == gravity_dir or dir == -gravity_dir:
			return false

		# Check if the rock is in freefall (fallen 2+ cells) — kills Repton
		var piece_id: int = level.get_map_id_at(target_grid)
		if piece_id >= 0 and piece_id < level.objects.size():
			var pushed_piece = level.objects[piece_id]
			if pushed_piece is Fallable:
				if pushed_piece.free_fall:
					die()
					return true

		var behind_grid: Vector3 = target_grid + dir
		var behind_piece: String = level.get_map_at(behind_grid)

		if behind_piece != "0" and behind_piece != "m":
			return false

		if piece_id >= 0 and piece_id < level.objects.size():
			var pushed_piece = level.objects[piece_id]
			if pushed_piece is Fallable:
				if not pushed_piece.move(dir):
					return false

		player_state = State.PUSH
		_do_grid_move(dir)
		return true

	# Door? Check for matching coloured key in inventory
	if target_piece == "D":
		var door_ref: int = level.get_map_ref_at(target_grid)
		var key_name: String = "Coloured Key:" + str(door_ref)
		if key_name in inventory:
			inventory.erase(key_name)
			level.remove_piece_v(target_grid)
			level.set_map_at(target_grid, "0")
			player_state = State.WALK
			_do_grid_move(dir)
			return true
		return false

	# Transporter? Teleport player
	if target_piece == "n":
		var ref_val: int = level.get_map_ref_at(target_grid)
		if ref_val >= 0 and ref_val < level.transporter.size():
			var dest: Vector3 = level.transporter[ref_val]
			last_position = grid_position
			grid_position = dest
			respawn_pos = dest
			direction = Vector3(0, 0, 1)
			position = _grid_to_world(dest)
			last_time = 0.0
			player_state = State.STOPPED
			SFX.play_at(self, SFX.transporter)
			return true
		return false

	# Traversable piece? Remove it and move in
	if target_piece in TRAVERSABLE_PIECES:
		_collect_piece(target_grid, target_piece)

		if target_piece == "e":
			player_state = State.DIG_AND_WALK
		else:
			player_state = State.WALK
		_do_grid_move(dir)
		return true

	# Empty space — just move (but check support in 3D levels)
	if target_piece == "0" or target_piece == "i":
		if level.has_player_gravity() and not _has_support_at(target_grid):
			return false
		player_state = State.WALK
		_do_grid_move(dir)
		return true

	return false


func _do_grid_move(dir: Vector3) -> void:
	# In 2D levels, check if moving in gravity direction while supporting a rock/egg
	if level != null and not level.has_player_gravity():
		var gravity_dir: Vector3 = level.get_gravity_dir()
		if dir == gravity_dir:
			var dominated: bool = false
			# Check directly above
			var above_pos: Vector3 = grid_position - gravity_dir
			var above_piece: String = level.get_map_at(above_pos)
			if above_piece == "r" or above_piece == "g":
				dominated = true
			# Check diagonal-above (top-left and top-right)
			# A rock at top-left can slide right-down onto Repton's current cell
			# A rock at top-right can slide left-down onto Repton's current cell
			if not dominated:
				# above_pos is directly above Repton — must be empty for diagonal slide
				if above_piece == "0":
					# Top-left rock: grid + (-1,0,-1) slides right-down via (1,0,1)
					var top_left: Vector3 = grid_position + Vector3(-1, 0, -1)
					var tl_piece: String = level.get_map_at(top_left)
					if tl_piece == "r" or tl_piece == "g":
						# Rock needs to be on a curved/slope piece to slide
						var tl_below: Vector3 = level.get_below(top_left)
						var tl_below_piece: String = level.get_map_at(tl_below)
						if tl_below_piece in Fallable.CURVED_PIECES or tl_below_piece in Fallable.SLOPES_RIGHT:
							dominated = true
					if not dominated:
						# Top-right rock: grid + (1,0,-1) slides left-down via (-1,0,1)
						var top_right: Vector3 = grid_position + Vector3(1, 0, -1)
						var tr_piece: String = level.get_map_at(top_right)
						if tr_piece == "r" or tr_piece == "g":
							var tr_below: Vector3 = level.get_below(top_right)
							var tr_below_piece: String = level.get_map_at(tr_below)
							if tr_below_piece in Fallable.CURVED_PIECES or tr_below_piece in Fallable.SLOPES_LEFT:
								dominated = true
			if dominated:
				_face_direction(dir)
				move(dir)
				die()
				return

	_face_direction(dir)
	move(dir)


func _on_move_finished() -> void:
	# Called when interpolation completes (from Movable)
	old_state = player_state
	last_direction = direction

	if player_state == State.WALK or player_state == State.PUSH or player_state == State.DIG_AND_WALK:
		player_state = State.STOPPED


func move_to_pos(new_pos: Vector3) -> void:
	# public void MoveToPos(Vector3 vNewPos)
	start_pos = new_pos
	respawn_pos = new_pos
	last_position = new_pos
	grid_position = new_pos
	position = _grid_to_world(new_pos)


func _check_player_gravity() -> bool:
	# Check if player should fall (3D levels only)
	# Repton can only fall 1 block — if below is empty, fall once
	var below_pos: Vector3 = level.get_below(grid_position)
	var below_piece: String = level.get_map_at(below_pos)

	# Standing on a skull — die
	if below_piece == "u":
		die()
		return true

	if below_piece == "0":
		# Check there is support 1 block below (i.e. 2 below current pos)
		var two_below: Vector3 = level.get_below(below_pos)
		var two_below_piece: String = level.get_map_at(two_below)
		if two_below_piece != "0":
			# Solid ground 1 block down — fall to it
			is_falling = true
			player_state = State.WALK
			_do_grid_move(level.get_gravity_dir())
			return true
		# Nothing below for 2+ blocks — don't fall (would fall out of level)
	is_falling = false
	return false


func _has_support_at(target: Vector3) -> bool:
	# Check if a position has ground support within a 1-block fall.
	# Returns true if target itself is on solid ground, or 1 block below is solid.
	# A falling rock/egg does NOT count as support.
	var below: Vector3 = level.get_below(target)
	var below_piece: String = level.get_map_at(below)
	if below_piece != "0":
		if not _is_falling_piece_at(below):
			return true  # Directly supported by a non-falling piece
	# Check 1 block further down
	var two_below: Vector3 = level.get_below(below)
	var two_below_piece: String = level.get_map_at(two_below)
	if two_below_piece != "0":
		return not _is_falling_piece_at(two_below)
	return false


func _is_falling_piece_at(pos: Vector3) -> bool:
	# Check if there's a falling or recently-fallen Fallable at the given position.
	# A rock that just landed (was_falling) may be about to fall again,
	# so it doesn't count as stable support either.
	var piece_id: int = level.get_map_id_at(pos)
	if piece_id >= 0 and piece_id < level.objects.size():
		var obj = level.objects[piece_id]
		if obj is Fallable and (obj.falling or obj.was_falling):
			return true
	return false


func _face_direction(dir: Vector3) -> void:
	# Tween the mesh node to face the movement direction (shortest rotation)
	if _mesh_node == null:
		return
	# Only rotate for horizontal movement (ignore pure vertical/gravity)
	if dir.x == 0 and dir.z == 0:
		return

	var target_angle: float = atan2(dir.x, dir.z)
	var current_angle: float = _mesh_node.rotation.y

	# Find shortest rotation by adjusting target to be within PI of current
	var diff: float = target_angle - current_angle
	diff = fmod(diff + PI, TAU) - PI  # Wrap to [-PI, PI]
	var final_angle: float = current_angle + diff

	if _face_tween:
		_face_tween.kill()
	_face_tween = create_tween()
	_face_tween.tween_property(_mesh_node, "rotation:y", final_angle, TURN_DURATION)


func die() -> int:
	# public int Die()
	lives -= 1
	print("Player died! Lives remaining: ", lives)

	if lives <= 0:
		# Game over
		if level != null and level.game != null:
			level.game.game_over()
		return 0

	# Reset to last safe position (start or transporter destination)
	var safe_pos: Vector3 = respawn_pos
	last_position = safe_pos
	grid_position = safe_pos
	position = _grid_to_world(safe_pos)
	direction = Vector3(0, 0, 1)   # Facing "down" (increasing grid_y)
	player_state = State.STOPPED
	last_time = 0.0

	return lives


func _wear_crown() -> void:
	var crown_node: Node3D = PieceFactory.get_fbx_node("t")
	if crown_node == null:
		return
	crown_node.name = "Crown"
	crown_node.scale = Vector3(0.5, 0.5, 0.5)
	crown_node.position = Vector3(0, 2.5, 0)
	if _mesh_node != null:
		_mesh_node.add_child(crown_node)
	else:
		add_child(crown_node)


func _collect_piece(pos: Vector3, piece: String) -> void:
	# Collect a traversable piece at the given position (pickup logic + remove)
	match piece:
		"d":
			level.diamonds -= 1
			SFX.play_at(self, SFX.diamond)
		"k":
			level.open_safes()
			SFX.play_at(self, SFX.key)
		"t":
			level.crowns -= 1
			SFX.play_at(self, SFX.crown)
			_wear_crown()
		"C":
			var ref_val: int = level.get_map_ref_at(pos)
			inventory.append("Coloured Key:" + str(ref_val))
			SFX.play_at(self, SFX.key)
		"z":
			if level.time_bomb > 0:
				level.time_bomb += 30.0
			SFX.play_at(self, SFX.time_capsule)
		"e":
			SFX.play_at(self, SFX.dig)
	level.remove_piece_v(pos)
	level.set_map_at(pos, "0")
