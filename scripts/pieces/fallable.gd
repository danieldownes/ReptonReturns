# fallable.gd
# Repton Returns - Godot 4.6 Port
# Base class for objects that can fall (rocks, eggs) with fall detection
# Original: Fallable.cs

class_name Fallable
extends Movable


signal stopped_falling    # public event Action StoppedFalling;

var falling: bool = false       # public bool Falling;
var was_falling: bool = false   # public bool WasFalling;
var free_fall: bool = false     # public bool FreeFall;

# Grid directions (grid_position.z = grid_y, so down = +z)
const GRID_DOWN := Vector3(0, 0, 1)        # Increasing grid_y = increasing z
const GRID_LEFT_DOWN := Vector3(-1, 0, 1)
const GRID_RIGHT_DOWN := Vector3(1, 0, 1)

# Piece types that rocks/eggs can slide off of diagonally
const CURVED_PIECES: Array = ["r", "g", "d"]  # Symmetric: can slide either direction

# Wall slopes — directional: rock slides off in one specific direction
# Numpad corner shapes: 7=╭ 9=╮ 1=╰ 3=╯
const SLOPES_LEFT: Array = ["7", "&", "1", "!"]    # Wall7, FilledWall7, Wall1, FilledWall1
const SLOPES_RIGHT: Array = ["9", "(", "3"]        # Wall9, FilledWall9, Wall3


func init() -> void:
	# public new void Init()
	super.init()
	falling = false
	check_if_fall()


func _process(delta: float) -> void:
	# private new void Update()
	super._process(delta)


func check_fall() -> void:
	# public void CheckFall()
	if last_time > 0.00:
		return
	check_if_fall()


func move(dir: Vector3) -> bool:
	# public override bool Move(Vector3 direction)

	# Not currently moving down? (Unity: Vector3.back = (0,0,-1))
	if dir == GRID_DOWN and last_time > 0.01:
		return false

	# Can't move up in 3D space (never happens in grid movement)
	if dir == Vector3(0, 1, 0):
		return false

	# Ok, start the move...
	super.move(dir)

	check_if_fall()

	return true


func traverse() -> void:
	# public override void Traverse()
	pass  # overridden in subclasses


func check_if_fall() -> void:
	# public virtual void CheckIfFall()

	if level == null:
		return

	# Have we stopped falling?
	was_falling = false

	if falling and last_time <= 0.0:
		falling = false
		was_falling = true
		stopped_falling.emit()
	elif falling:
		return

	var grid_x: int = int(grid_position.x)
	var grid_y: int = int(grid_position.z)

	# Fall straight down?
	var below: String = level.get_map_p_xy(grid_x, grid_y + 1)

	if below == "0" and not _is_player_at(grid_x, grid_y + 1):
		# Empty below and player not supporting - fall straight down
		falling = true
		# Track free fall (consecutive fall = fell more than 1 cell)
		if was_falling:
			free_fall = true
		else:
			free_fall = false

		_do_fall(GRID_DOWN)
		return

	# Diagonal sliding based on what we're resting on
	var can_slide_left: bool = below in CURVED_PIECES or below in SLOPES_LEFT
	var can_slide_right: bool = below in CURVED_PIECES or below in SLOPES_RIGHT

	if can_slide_left:
		var left: String = level.get_map_p_xy(grid_x - 1, grid_y)
		var left_below: String = level.get_map_p_xy(grid_x - 1, grid_y + 1)

		if left == "0" and left_below == "0" \
				and not _is_player_at(grid_x - 1, grid_y) \
				and not _is_player_at(grid_x - 1, grid_y + 1):
			falling = true
			free_fall = was_falling
			_do_fall(GRID_LEFT_DOWN)
			return

	if can_slide_right:
		var right: String = level.get_map_p_xy(grid_x + 1, grid_y)
		var right_below: String = level.get_map_p_xy(grid_x + 1, grid_y + 1)

		if right == "0" and right_below == "0" \
				and not _is_player_at(grid_x + 1, grid_y) \
				and not _is_player_at(grid_x + 1, grid_y + 1):
			falling = true
			free_fall = was_falling
			_do_fall(GRID_RIGHT_DOWN)
			return


func _do_fall(dir: Vector3) -> void:
	# Update map data then start the animated move
	_update_map_for_move(dir)
	# Call Movable.move() directly to avoid Rock's obstacle check
	# (we already know the destination is empty)
	super.move(dir)
	# Re-check for continued falling
	check_if_fall()


func _is_player_at(x: int, y: int) -> bool:
	# Check if Repton is at the given grid position (player isn't tracked on map)
	if level.game == null or level.game.player == null:
		return false
	var player = level.game.player
	return int(player.grid_position.x) == x and int(player.grid_position.z) == y


func _update_map_for_move(dir: Vector3) -> void:
	# Move piece data in the map from current cell to destination cell
	if level == null:
		return

	var old_x: int = int(grid_position.x)
	var old_y: int = int(grid_position.z)
	var new_x: int = int(grid_position.x + dir.x)
	var new_y: int = int(grid_position.z + dir.z)

	var my_id: int = level.map_detail[old_x][old_y]["id"]

	level.map_detail[new_x][new_y]["type_id"] = piece_type
	level.map_detail[new_x][new_y]["id"] = my_id
	level.map_detail[old_x][old_y]["type_id"] = "0"
	level.map_detail[old_x][old_y]["id"] = -1
