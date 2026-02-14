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
var player_state: int = State.STOPPED  # public State PlayerState;
var old_state: int = State.STOPPED     # private State OldState;

var can_move: bool = true        # public bool CanMove = true;
var lives: int = 3               # public int Lives;
var want_move_me: int = 0        # private int WantMoveMe;

var inventory: Array[String] = []  # public List<string> Inventory = new List<string>();

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

	# Register input actions
	_setup_input_actions()


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
	# private new void Update()

	# Handle movement interpolation (from Movable base)
	if last_time > 0.0:
		_do_move(delta)
		return  # Don't accept input while moving

	# Movement complete - update state
	if player_state == State.WALK or player_state == State.PUSH:
		old_state = player_state
		player_state = State.STOPPED

	# Input handling
	# Original: Input.GetAxis("Horizontal") / Input.GetAxis("Vertical")
	if player_state == State.STOPPED or player_state == State.PUSH_NO_WALK:
		# Grid directions: left=(-1,0,0), right=(1,0,0), up=(0,0,-1), down=(0,0,1)
		if Input.is_action_pressed("move_left"):
			try_move(Vector3.LEFT)
		elif Input.is_action_pressed("move_right"):
			try_move(Vector3.RIGHT)
		elif Input.is_action_pressed("move_forward"):
			try_move(Vector3(0, 0, -1))  # Grid up = -Z (decreasing grid_y)
		elif Input.is_action_pressed("move_back"):
			try_move(Vector3(0, 0, 1))   # Grid down = +Z (increasing grid_y)

	# Was pushing (continuously), and now stopped?
	if old_state == State.PUSH and player_state != State.PUSH:
		pass  # Stop pushing sound

	if want_move_me > 0:
		want_move_me -= 1


func try_move(dir: Vector3) -> void:
	# public new void Move(Vector3 direction)

	if level == null:
		return

	var target_grid: Vector3 = grid_position + dir
	var target_x: int = int(target_grid.x)
	var target_y: int = int(target_grid.z)

	var target_piece: String = level.get_map_p_xy(target_x, target_y)

	# Wall or barrier? Can't move
	if target_piece in WALL_PIECES:
		return

	# Deadly piece? Player dies
	if target_piece in DEADLY_PIECES:
		die()
		return

	# Bomb? Only traversable when all objectives complete
	if target_piece == "b":
		if level.diamonds <= 0 and level.crowns <= 0 and level.eggs <= 0 and level.monsters_alive <= 0:
			# Defuse bomb — level complete!
			level.remove_piece(target_x, target_y)
			level.map_detail[target_x][target_y]["type_id"] = "0"
			player_state = State.WALK
			_do_grid_move(dir)
			if level.game != null:
				level.game.level_complete()
		return

	# Cage? Can't enter directly (spirits turn into diamonds here)
	if target_piece == "c":
		return

	# Monster? Player dies on contact
	if target_piece == "m":
		die()
		return

	# Spirit? Player dies on contact
	if target_piece == "p":
		die()
		return

	# Rock or Egg? Try to push
	if target_piece == "r" or target_piece == "g":
		var behind_grid: Vector3 = target_grid + dir
		var behind_x: int = int(behind_grid.x)
		var behind_y: int = int(behind_grid.z)
		var behind_piece: String = level.get_map_p_xy(behind_x, behind_y)

		if behind_piece != "0":
			return  # Can't push — something behind it

		# Can only push horizontally (not up/down)
		# (In classic Repton, rocks fall, they don't get pushed vertically)

		# Get the fallable node and animate the push
		var piece_id: int = level.map_detail[target_x][target_y]["id"]
		if piece_id >= 0 and piece_id < level.objects.size():
			var pushed_piece = level.objects[piece_id]
			if pushed_piece is Fallable:
				if not pushed_piece.move(dir):
					return  # Rock couldn't move — don't walk into it

		player_state = State.PUSH
		_do_grid_move(dir)
		return

	# Door? Check for matching coloured key in inventory
	if target_piece == "D":
		var door_ref: int = level.map_detail[target_x][target_y]["ref"]
		var key_name: String = "Coloured Key:" + str(door_ref)
		if key_name in inventory:
			# Open the door
			inventory.erase(key_name)
			level.remove_piece(target_x, target_y)
			level.map_detail[target_x][target_y]["type_id"] = "0"
			player_state = State.WALK
			_do_grid_move(dir)
		return

	# Transporter? Teleport player
	if target_piece == "n":
		var ref_val: int = level.map_detail[target_x][target_y]["ref"]
		if ref_val >= 0 and ref_val < level.transporter.size():
			var dest: Vector3 = level.transporter[ref_val]
			last_position = grid_position
			grid_position = dest
			direction = Vector3(0, 0, 1)   # Face down after transport (increasing grid_y)
			position = _grid_to_world(dest)
			last_time = 0.0
			player_state = State.STOPPED
		return

	# Traversable piece? Remove it and move in
	if target_piece in TRAVERSABLE_PIECES:
		# Handle special pickups
		match target_piece:
			"d":
				# Diamond collected
				level.diamonds -= 1
			"k":
				# Key collected — open safes
				level.open_safes()
			"t":
				# Crown collected
				level.crowns -= 1
			"C":
				# Coloured key — add to inventory
				var ref_val: int = level.map_detail[target_x][target_y]["ref"]
				inventory.append("Coloured Key:" + str(ref_val))
			"z":
				# Time capsule — add time to bomb timer
				if level.time_bomb > 0:
					level.time_bomb += 30.0  # Add 30 seconds
			"x":
				# Map — reveals level map (UI feature)
				pass
			"s":
				# Safe — just collect
				pass

		# Remove the piece from map and scene
		level.remove_piece(target_x, target_y)
		level.map_detail[target_x][target_y]["type_id"] = "0"

		player_state = State.WALK
		_do_grid_move(dir)
		return

	# Empty space — just move
	if target_piece == "0" or target_piece == "i":
		player_state = State.WALK
		_do_grid_move(dir)
		return


func _do_grid_move(dir: Vector3) -> void:
	# Start the interpolated move (calls Movable.move())
	move(dir)


func _on_move_finished() -> void:
	# Called when interpolation completes (from Movable)
	old_state = player_state
	last_direction = direction

	if player_state == State.WALK or player_state == State.PUSH:
		player_state = State.STOPPED


func move_to_pos(new_pos: Vector3) -> void:
	# public void MoveToPos(Vector3 vNewPos)
	start_pos = new_pos
	last_position = new_pos
	grid_position = new_pos
	position = _grid_to_world(new_pos)


func die() -> int:
	# public int Die()
	lives -= 1
	print("Player died! Lives remaining: ", lives)

	if lives <= 0:
		# Game over
		if level != null and level.game != null:
			level.game.game_over()
		return 0

	# Reset to starting position
	move_to_pos(start_pos)
	direction = Vector3(0, 0, 1)   # Facing "down" (increasing grid_y)
	player_state = State.STOPPED
	last_time = 0.0

	return lives
