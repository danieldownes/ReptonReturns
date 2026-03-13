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
	var gravity_dir: Vector3 = level.get_gravity_dir() if level != null else Vector3(0, 0, 1)
	if dir == gravity_dir and last_time > 0.01:
		return false

	# Can't move up in 3D space (never happens in grid movement)
	if dir == Vector3(0, 1, 0):
		return false

	# If pushed horizontally while falling, reset fall state
	if falling and dir != gravity_dir:
		falling = false
		was_falling = false

	# Ok, start the move...
	super.move(dir)

	# Don't chain check_if_fall() here — let the move animation complete first.
	# Fall checks happen naturally via _process -> check_fall().

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
		# Update process priority so bottom rocks always fall first
		if level.has_player_gravity():
			process_priority = int(grid_position.y) - 1000
		else:
			process_priority = -int(grid_position.z) - 1
		stopped_falling.emit()
	elif falling:
		return

	var gravity_dir: Vector3 = level.get_gravity_dir()

	# Fall straight down?
	var below_pos: Vector3 = level.get_below(grid_position)
	var below: String = level.get_map_at(below_pos)

	if (below == "0" or below == "m") and not _is_player_at_v(below_pos):
		# Empty below and player not supporting - fall straight down
		falling = true
		# Track free fall (consecutive fall = fell more than 1 cell)
		if was_falling:
			free_fall = true
		else:
			free_fall = false

		_do_fall(gravity_dir)
		return

	# Diagonal sliding based on what we're resting on
	var slide_dirs: Array = level.get_slide_directions()

	# In 2D, slide_dirs[0] = left-down, slide_dirs[1] = right-down
	# Determine slide eligibility based on what's below
	var can_slide_left: bool = below in CURVED_PIECES or below in SLOPES_LEFT
	var can_slide_right: bool = below in CURVED_PIECES or below in SLOPES_RIGHT

	if can_slide_left and slide_dirs.size() > 0:
		var slide_dir: Vector3 = slide_dirs[0]
		var side_pos: Vector3 = grid_position + (slide_dir - gravity_dir)  # horizontal component
		var slide_pos: Vector3 = grid_position + slide_dir
		var slide_piece: String = level.get_map_at(slide_pos)

		if level.get_map_at(side_pos) == "0" and (slide_piece == "0" or slide_piece == "m") \
				and not _is_player_at_v(side_pos) \
				and not _is_player_at_v(slide_pos):
			falling = true
			free_fall = was_falling
			_do_fall(slide_dir)
			return

	if can_slide_right and slide_dirs.size() > 1:
		var slide_dir: Vector3 = slide_dirs[1]
		var side_pos: Vector3 = grid_position + (slide_dir - gravity_dir)  # horizontal component
		var slide_pos: Vector3 = grid_position + slide_dir
		var slide_piece: String = level.get_map_at(slide_pos)

		if level.get_map_at(side_pos) == "0" and (slide_piece == "0" or slide_piece == "m") \
				and not _is_player_at_v(side_pos) \
				and not _is_player_at_v(slide_pos):
			falling = true
			free_fall = was_falling
			_do_fall(slide_dir)
			return


func _do_fall(dir: Vector3) -> void:
	# Kill monster at destination if present
	if level != null:
		var dest: Vector3 = grid_position + dir
		var dest_piece: String = level.get_map_at(dest)
		if dest_piece == "m":
			_kill_monster_at_fall(dest)

	# Update map data then start the animated move
	_update_map_for_move(dir)
	# Call Movable.move() directly to avoid Rock's obstacle check
	# (we already know the destination is empty/cleared)
	super.move(dir)
	# Don't chain check_if_fall() here — let the fall animation complete first.
	# The next fall check happens naturally via _process -> check_fall().
	# This gives Repton a window to push the rock mid-fall (the "Repton shuffle").


func _is_player_at(x: int, y: int) -> bool:
	# Check if Repton is at the given grid position (player isn't tracked on map)
	if level.game == null or level.game.player == null:
		return false
	var player = level.game.player
	return int(player.grid_position.x) == x and int(player.grid_position.z) == y

func _is_player_at_v(pos: Vector3) -> bool:
	# Check if Repton is at the given grid position (Vector3 version)
	if level.game == null or level.game.player == null:
		return false
	var player = level.game.player
	return int(player.grid_position.x) == int(pos.x) \
		and int(player.grid_position.y) == int(pos.y) \
		and int(player.grid_position.z) == int(pos.z)


func _kill_monster_at_fall(pos: Vector3) -> void:
	# Kill a monster at the given position (called during fall)
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


func _update_map_for_move(dir: Vector3) -> void:
	# Move piece data in the map from current cell to destination cell
	if level == null:
		return

	var old_pos: Vector3 = grid_position
	var new_pos: Vector3 = grid_position + dir

	var my_id: int = level.get_map_id_at(old_pos)

	level.set_map_at(new_pos, piece_type)
	level.set_map_id_at(new_pos, my_id)
	level.set_map_at(old_pos, "0")
	level.set_map_id_at(old_pos, -1)
