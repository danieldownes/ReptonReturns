# level3d.gd
# Repton Returns - 3D Voxel Level (sparse)
# Stores only occupied cells in a Dictionary keyed by "x,y,z" strings.
# No fixed grid bounds — levels can be any shape or size.

class_name Level3D
extends Node3D


var game: Node3D

# Sparse map: key = "x,y,z" string, value = {"type_id", "id", "ref"}
var _cells: Dictionary = {}

var transporter: PackedVector3Array = []
var colour_key: Array[int] = []
var piece_totals: Dictionary = {}

var objects: Array = []
var _obj_tot: int = 0

var start_pos: Vector3

var level_time: float = 0.0
var time_bomb: float = -1.0

var diamonds: int = 0
var crowns: int = 0
var eggs: int = 0
var monsters_alive: int = 0
var spirits: int = 0
var monsters: int = 0

var pieces_container: Node3D
var movables_container: Node3D

# 2D compat stubs (not used in 3D but some code paths reference them)
var map_size_x: int = 0
var map_size_y: int = 0


static func _key(v: Vector3) -> String:
	return str(int(v.x)) + "," + str(int(v.y)) + "," + str(int(v.z))

static func _key_xyz(x: int, y: int, z: int) -> String:
	return str(x) + "," + str(y) + "," + str(z)


func _ready() -> void:
	pieces_container = Node3D.new()
	pieces_container.name = "Pieces"
	add_child(pieces_container)

	movables_container = Node3D.new()
	movables_container.name = "Movables"
	add_child(movables_container)


# === Abstraction interface ===

func grid_to_world_v(gp: Vector3) -> Vector3:
	return Vector3(gp.x, gp.y, gp.z)

func get_map_at(grid_pos: Vector3) -> String:
	var k := _key(grid_pos)
	if _cells.has(k):
		return _cells[k]["type_id"]
	return "0"  # Empty — unbounded space is traversable

func set_map_at(grid_pos: Vector3, type: String) -> void:
	var k := _key(grid_pos)
	if type == "0":
		# Remove empty cells to keep dictionary sparse
		if _cells.has(k):
			_cells[k]["type_id"] = "0"
	else:
		if _cells.has(k):
			_cells[k]["type_id"] = type
		else:
			_cells[k] = {"type_id": type, "id": -1, "ref": 0}

func get_map_id_at(grid_pos: Vector3) -> int:
	var k := _key(grid_pos)
	if _cells.has(k):
		return _cells[k]["id"]
	return -1

func set_map_id_at(grid_pos: Vector3, id: int) -> void:
	var k := _key(grid_pos)
	if _cells.has(k):
		_cells[k]["id"] = id
	else:
		_cells[k] = {"type_id": "0", "id": id, "ref": 0}

func get_map_ref_at(grid_pos: Vector3) -> int:
	var k := _key(grid_pos)
	if _cells.has(k):
		return _cells[k]["ref"]
	return 0

func get_gravity_dir() -> Vector3:
	return Vector3(0, -1, 0)

func get_below(grid_pos: Vector3) -> Vector3:
	return grid_pos + Vector3(0, -1, 0)

func get_slide_directions() -> Array:
	return [
		Vector3(-1, -1, 0),
		Vector3(1, -1, 0),
		Vector3(0, -1, -1),
		Vector3(0, -1, 1),
	]

func is_in_bounds(_grid_pos: Vector3) -> bool:
	return true  # No bounds — sparse world

func has_player_gravity() -> bool:
	return true


# === Map compatibility functions ===

func get_map_p(v: Vector3) -> String:
	return get_map_at(v)

func get_map_p_xy(x: int, y: int) -> String:
	return get_map_at(Vector3(x, 0, y))

func get_map_p_id(v: Vector3) -> int:
	return get_map_id_at(v)

func set_map_p(v: Vector3, c_type: String) -> void:
	set_map_at(v, c_type)

func set_map_p_with_id(v: Vector3, c_type: String, id: int) -> void:
	set_map_at(v, c_type)
	set_map_id_at(v, id)

func add_slant(v: Vector3) -> Vector3:
	return grid_to_world_v(v)

func grid_to_world(grid_x: int, grid_y: int) -> Vector3:
	return Vector3(grid_x, 0, grid_y)


# === Piece management ===

func remove_piece(x: int, y: int) -> void:
	remove_piece_v(Vector3(x, 0, y))

func remove_piece_v(v: Vector3) -> void:
	var k := _key(v)
	if _cells.has(k):
		var p_id: int = _cells[k]["id"]
		if p_id != -1 and p_id < objects.size() and objects[p_id] != null:
			objects[p_id].queue_free()

func replace_piece(x: int, y: int, new_type_id: String) -> void:
	replace_piece_v(Vector3(x, 0, y), new_type_id)

func replace_piece_v(v: Vector3, new_type_id: String) -> void:
	var k := _key(v)
	var p_id: int = -1
	if _cells.has(k):
		p_id = _cells[k]["id"]

	set_map_at(v, new_type_id)

	if p_id >= 0 and p_id < objects.size() and objects[p_id] != null:
		objects[p_id].queue_free()

	if new_type_id != "0":
		var new_piece: Node3D = PieceFactory.create_piece(new_type_id, true)
		if new_piece != null:
			new_piece.position = grid_to_world_v(v)
			pieces_container.add_child(new_piece)
			if p_id >= 0 and p_id < objects.size():
				objects[p_id] = new_piece

func move_piece(from_x: int, from_y: int, to_x: int, to_y: int) -> bool:
	var from_v := Vector3(from_x, 0, from_y)
	var to_v := Vector3(to_x, 0, to_y)
	return _move_piece_v(from_v, to_v)

func _move_piece_v(from_v: Vector3, to_v: Vector3) -> bool:
	var from_type: String = get_map_at(from_v)
	var to_type: String = get_map_at(to_v)
	if to_type != "0":
		return false

	var piece_id: int = get_map_id_at(from_v)

	set_map_at(to_v, from_type)
	set_map_id_at(to_v, piece_id)
	set_map_at(from_v, "0")
	set_map_id_at(from_v, -1)

	if piece_id >= 0 and piece_id < objects.size() and objects[piece_id] != null:
		objects[piece_id].position = grid_to_world_v(to_v)
	return true


func open_safes() -> void:
	for k in _cells.keys():
		if _cells[k]["type_id"] == "s":
			var parts = k.split(",")
			var v := Vector3(int(parts[0]), int(parts[1]), int(parts[2]))
			replace_piece_v(v, "d")


# === Piece total tracking ===

func _get_piece_total(piece_char: String) -> int:
	return piece_totals.get(piece_char, 0)

func _inc_piece_total(piece_char: String) -> void:
	piece_totals[piece_char] = piece_totals.get(piece_char, 0) + 1

func _set_piece_total(piece_char: String, value: int) -> void:
	piece_totals[piece_char] = value


# === Level loading ===
# File format (.rrl3d):
#   ReptonReturnsLevel3DV1.0
#   Level Name
#   time (-1 = unlimited)
#   ---PIECES---
#   x,y,z,type
#   x,y,z,type
#   ...
#   ---TRANSPORTERS---
#   x1,y1,z1,x2,y2,z2
#   ...
#   ---COLOURKEYS---
#   idx1;idx2;...
#   ---END---

func load_file_level_3d(file_path: String) -> bool:
	_cells.clear()
	objects.clear()
	_obj_tot = 0
	piece_totals.clear()
	colour_key = [0, 0, 0, 0, 0]
	diamonds = 0
	crowns = 0
	eggs = 0
	monsters_alive = 0
	spirits = 0

	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("3D Level file not found: " + file_path)
		return false

	# Version
	var line: String = file.get_line()
	print("Level3D version: ", line)

	# Level name
	line = file.get_line()
	print("Level3D name: ", line)

	# Time
	line = file.get_line()
	time_bomb = float(line) if line != "" else -1.0

	# Read sections
	var section: String = ""
	var piece_entries: Array = []  # Store for two-pass processing
	var transporter_pairs: Array = []

	while not file.eof_reached():
		line = file.get_line().strip_edges()
		if line == "":
			continue

		if line.begins_with("---"):
			section = line
			continue

		if section == "---PIECES---":
			piece_entries.append(line)
		elif section == "---TRANSPORTERS---":
			transporter_pairs.append(line)
		elif section == "---COLOURKEYS---":
			var parts = line.split(";")
			for n in range(parts.size()):
				colour_key[n] = int(parts[n])
		elif section == "---END---":
			break

	file.close()

	# First pass: count piece totals and set up transporters
	var transporter_idx: int = 0
	for entry in piece_entries:
		var parts = entry.split(",")
		if parts.size() < 4:
			continue
		var c: String = parts[3]
		_inc_piece_total(c)

	# Set up transporter destinations
	# Each line: src_x,src_y,src_z,dest_x,dest_y,dest_z
	# Stored in a temp dict keyed by source pos, resolved to ref indices in second pass
	var _transporter_dest_map: Dictionary = {}  # "x,y,z" -> Vector3 dest
	for pair_line in transporter_pairs:
		var parts = pair_line.split(",")
		if parts.size() < 6:
			continue
		var src_key: String = parts[0] + "," + parts[1] + "," + parts[2]
		var dest := Vector3(int(parts[3]), int(parts[4]), int(parts[5]))
		_transporter_dest_map[src_key] = dest

	var total_transporters: int = _get_piece_total("n")
	transporter.resize(total_transporters)

	_set_piece_total("C", 0)
	_set_piece_total("D", 0)

	# Second pass: create cells and pieces
	transporter_idx = 0
	for entry in piece_entries:
		var parts = entry.split(",")
		if parts.size() < 4:
			continue
		var x: int = int(parts[0])
		var y: int = int(parts[1])
		var z: int = int(parts[2])
		var c_t: String = parts[3]
		var pos := Vector3(x, y, z)
		var k := _key(pos)

		# Create cell
		_cells[k] = {"type_id": c_t, "id": -1, "ref": 0}

		if c_t == "n":
			_cells[k]["ref"] = transporter_idx
			# Resolve destination from saved transporter data
			var src_key := str(x) + "," + str(y) + "," + str(z)
			if _transporter_dest_map.has(src_key) and transporter_idx < total_transporters:
				transporter[transporter_idx] = _transporter_dest_map[src_key]
			transporter_idx += 1

		if c_t == "C":
			_cells[k]["ref"] = _get_piece_total("C")
			_inc_piece_total("C")

		if c_t == "D":
			var door_idx: int = _get_piece_total("D")
			_cells[k]["ref"] = door_idx
			_inc_piece_total("D")

		# Skip empty
		if c_t == "0":
			continue

		# Player start
		if c_t == "i":
			start_pos = pos
			_cells[k]["type_id"] = "0"
			continue

		# Count objectives
		match c_t:
			"d": diamonds += 1
			"t": crowns += 1
			"g": eggs += 1
			"m": monsters_alive += 1
			"p": spirits += 1

		# Create piece node
		var piece_node: Node3D = PieceFactory.create_piece(c_t, true)
		if piece_node == null:
			continue

		piece_node.position = grid_to_world_v(pos)
		piece_node.name = c_t + "_" + str(x) + "_" + str(y) + "_" + str(z)
		_cells[k]["id"] = _obj_tot

		if piece_node is Movable:
			piece_node.piece_type = c_t
			piece_node.grid_position = pos
			piece_node.level = self

		# Fallables process bottom-up so lower rocks fall first
		if piece_node is Fallable:
			piece_node.process_priority = y - 1000

		if piece_node is Monster:
			piece_node.monster_init(pos)
		elif piece_node is Spirit:
			piece_node.spirit_init(pos)

		pieces_container.add_child(piece_node)
		objects.append(piece_node)
		_obj_tot += 1

	print("Level3D loaded. Pieces: ", _obj_tot,
		" Diamonds:", diamonds, " Crowns:", crowns,
		" Eggs:", eggs, " Monsters:", monsters_alive)
	return true
