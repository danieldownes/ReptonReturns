# level.gd
# Repton Returns - Godot 4.6 Port
# Level loading, map data management (30x30 grid), piece instantiation
# Original: Level.cs

class_name Level
extends Node3D


var game: Node3D    # public Game game; (typed as Node3D to avoid circular ref)

var map_size_x: int = 30         # public int MapSizeX;
var map_size_y: int = 30         # public int MapSizeY;
const MAP_SLANT: float = 0.35    # public float fMapSlant = 0.35f; // For every Z, Y increases this much

var map_detail: Array = []       # public MapPiece2d[,] MapDetail;

var transporter: PackedVector3Array = []   # public Vector3[] tTransporter;

var colour_key: Array[int] = []  # public int[] colourKey;
var piece_totals: Dictionary = {}  # public int[] iPieceTot;

var objects: Array = []          # public List<GameObject> lObjects3 = new List<GameObject>();
var _obj_tot: int = 0            # private int iObjTot;

var start_pos: Vector3           # public Vector3 vStartPos;


# Timing
var level_time: float = 0.0      # float fTime;
var time_bomb: float = -1.0      # float fTimeBomb;

# Totals in level:
var diamonds: int = 0            # public int iDiamonds;
var crowns: int = 0              # public int iCrowns;
var eggs: int = 0                # public int iEggs;
var monsters_alive: int = 0      # public int iMonstersAlive;
var spirits: int = 0             # public int iSpirits;

var monsters: int = 0            # public int iMonsters;


# Piece type characters from .rrl files
# Original: public enum Piece
# Used characters:   abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ%*)^$(&
enum PieceChar {
	SPACE = 0x30,          # '0'
	DIAMOND = 0x64,        # 'd'
	WALL = 0x35,           # '5'
	WALL8 = 0x38,          # '8'
	WALL2 = 0x32,          # '2'
	WALL6 = 0x36,          # '6'
	WALL4 = 0x34,          # '4'
	WALL9 = 0x39,          # '9'
	WALL7 = 0x37,          # '7'
	WALL3 = 0x33,          # '3'
	WALL1 = 0x31,          # '1'
	EARTH = 0x65,          # 'e'
	ROCK = 0x72,           # 'r'
	SAFE = 0x73,           # 's'
	KEY = 0x6B,            # 'k'
	EGG = 0x67,            # 'g'
	REPTON = 0x69,         # 'i'
	CROWN = 0x74,          # 't'
	CAGE = 0x63,           # 'c'
	SPIRIT = 0x70,         # 'p'
	BOMB = 0x62,           # 'b'
	FUNGUS = 0x66,         # 'f'
	SKULL = 0x75,          # 'u'
	BARRIER = 0x61,        # 'a'
	MONSTER = 0x6D,        # 'm'
	TRANSPORTER = 0x6E,    # 'n'
	TIME_CAPSULE = 0x7A,   # 'z'
	FILLED_WALL = 0x25,    # '%'
	MAP = 0x78,            # 'x'
	LEVEL_TRANSPORT = 0x79,# 'y'
	COLOUR_KEY = 0x43,     # 'C'
	DOOR = 0x44            # 'D'
}


# Container nodes
var pieces_container: Node3D
var movables_container: Node3D


func _ready() -> void:
	pieces_container = Node3D.new()
	pieces_container.name = "Pieces"
	add_child(pieces_container)

	movables_container = Node3D.new()
	movables_container.name = "Movables"
	add_child(movables_container)


func load_file_level(file_path: String) -> bool:
	# public bool LoadFileLevel()

	map_size_x = 30
	map_size_y = 30

	# Initialize map_detail as 2D array [x][y]
	map_detail = []
	for x in range(map_size_x):
		var column: Array = []
		for y in range(map_size_y):
			column.append({
				"type_id": "0",  # char TypeID
				"id": -1,        # int id
				"ref": 0         # int iRef
			})
		map_detail.append(column)

	objects.clear()
	_obj_tot = 0

	# iPieceTot = new int[110];
	piece_totals.clear()

	# colourKey = new int[5];
	colour_key = [0, 0, 0, 0, 0]

	var s_temp: String

	# Read file using Godot FileAccess
	# Original used Unity TextAsset/StringReader
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Level file not found or not readable: " + file_path)
		return false

	# RR file version
	s_temp = file.get_line()  # expecting "ReptonReturnsLevelV1.1"
	print("Level version: ", s_temp)

	# Level Name
	s_temp = file.get_line()
	print("Level name: ", s_temp)

	# Time allowed
	s_temp = file.get_line()  # sngTimeBombOut
	time_bomb = float(s_temp) if s_temp != "" else -1.0

	# Map Size
	s_temp = file.get_line()
	print("Map size: ", s_temp)
	var dim_parts := s_temp.split(",")
	map_size_x = int(dim_parts[0])
	map_size_y = int(dim_parts[1])

	print(str(map_size_x) + ":" + str(map_size_y))


	# Get map layout data
	for y in range(map_size_y):
		s_temp = file.get_line()
		print(s_temp)

		for x in range(map_size_x):
			if x < 0 or x >= (map_size_x - 2) or y < 0 or y >= (map_size_y - 2):
				pass
			else:
				# Else use read in value
				if x < s_temp.length():
					map_detail[x][y]["type_id"] = s_temp[x]

					if s_temp[x] == "n":  # Transporter
						map_detail[x][y]["ref"] = _get_piece_total("n")

					# Count piece types
					_inc_piece_total(s_temp[x])


	# Transporter info (indexed in order as from map)
	var transporter_count: int = _get_piece_total("n")
	transporter.resize(transporter_count)

	for n in range(transporter_count):
		s_temp = file.get_line()
		print("transporter:" + s_temp)
		var a_temp := s_temp.split(",")
		transporter[n] = Vector3(
			int(a_temp[0]) - 1,
			0,
			int(a_temp[1]) - 1
		)


	# Number of transporters line (already consumed if count > 0, otherwise read it)
	if transporter_count == 0:
		s_temp = file.get_line()

	# In-game messages data
	s_temp = file.get_line()
	print("Messages: ", s_temp)

	# Navigation map is present from start
	s_temp = file.get_line()
	print("Nav map: ", s_temp)


	# Coloured Keys, door info
	# data eg: 2;4;3   .. key 0 opens door 2, key 1 opens door 4, etc...
	var colour_key_count: int = _get_piece_total("C")
	if colour_key_count > 0:
		s_temp = file.get_line()
		print("Coloured Keys:" + s_temp)

		var a_key_temp := s_temp.split(";")
		for n in range(a_key_temp.size()):
			colour_key[n] = int(a_key_temp[n])
			print("Key" + str(n) + " = " + a_key_temp[n])


	# Finished reading file
	file.close()


	# Post-read operations
	_set_piece_total("C", 0)  # Reset coloured key count
	_set_piece_total("D", 0)  # Reset door count


	# Process map data - create 3D pieces
	for y in range(map_size_y):
		for x in range(map_size_x):
			var world_pos: Vector3 = Vector3(x * 1.0, -y , y * MAP_SLANT)

			# Skip border padding (border walls are created outside the map)
			if x < 0 or x >= (map_size_x - 2) or y < 0 or y >= (map_size_y - 2):
				pass
			else:
				var c_t: String = map_detail[x][y]["type_id"]
				var s_extra: String = ""

				# Coloured Key
				if c_t == "C":
					s_extra = str(_get_piece_total("C"))
					map_detail[x][y]["ref"] = _get_piece_total("C")
					_inc_piece_total("C")

				# Door
				if c_t == "D":
					var door_idx: int = _get_piece_total("D")
					s_extra = str(colour_key[door_idx])
					map_detail[x][y]["ref"] = door_idx
					_inc_piece_total("D")

				# Skip empty space
				if c_t == "0":
					continue

				# Player start position - record but don't create a mesh
				# (player is created separately by Game)
				if c_t == "i":
					start_pos.x = x
					start_pos.z = y
					map_detail[x][y]["type_id"] = "0"  # Clear from map
					continue

				# Count objectives
				if c_t == "d":
					diamonds += 1
				elif c_t == "t":
					crowns += 1
				elif c_t == "g":
					eggs += 1
				elif c_t == "m":
					monsters_alive += 1
				elif c_t == "p":
					spirits += 1

				# Create piece
				var piece_node: Node3D = PieceFactory.create_piece(c_t)
				if piece_node == null:
					map_detail[x][y]["id"] = -1
					continue

				piece_node.position = world_pos
				piece_node.name = c_t + "_" + str(x) + "_" + str(y)
				map_detail[x][y]["id"] = _obj_tot

				# Pass level reference to active pieces
				if piece_node is Movable:
					piece_node.piece_type = c_t
					piece_node.grid_position = Vector3(x, 0, y)
					piece_node.level = self

				# Type-specific initialization
				if piece_node is Monster:
					piece_node.monster_init(Vector3(x, 0, y))
				elif piece_node is Spirit:
					piece_node.spirit_init(Vector3(x, 0, y))

				pieces_container.add_child(piece_node)
				objects.append(piece_node)
				_obj_tot += 1

	# Create border walls around the outside of the map
	_create_border_walls()

	print("Level loaded. Pieces created: ", _obj_tot,
		" Diamonds:", diamonds, " Crowns:", crowns,
		" Eggs:", eggs, " Monsters:", monsters_alive)
	return true


# Piece total tracking helpers

func _get_piece_total(piece_char: String) -> int:
	return piece_totals.get(piece_char, 0)

func _inc_piece_total(piece_char: String) -> void:
	piece_totals[piece_char] = piece_totals.get(piece_char, 0) + 1

func _set_piece_total(piece_char: String, value: int) -> void:
	piece_totals[piece_char] = value


# Coordinate helpers

func add_slant(v: Vector3) -> Vector3:
	# Convert grid_position (x, 0, grid_y) to world position
	# World: (x, -grid_y, grid_y * slant)
	return Vector3(v.x, -v.z, v.z * MAP_SLANT)


func grid_to_world(grid_x: int, grid_y: int) -> Vector3:
	return Vector3(grid_x * 1.0, -grid_y, grid_y * MAP_SLANT)


# Map data functions

func get_map_p(v: Vector3) -> String:
	# public char GetMapP(Vector3 vP)
	return get_map_p_xy(int(v.x), int(v.z))

func get_map_p_xy(x: int, y: int) -> String:
	# public char GetMapP(int x, int y)
	if x >= 0 and x < map_size_x and y >= 0 and y < map_size_y:
		return map_detail[x][y]["type_id"]
	else:
		return " "

func get_map_p_id(v: Vector3) -> int:
	# public int GetMapPId(Vector3 vP)
	return map_detail[int(v.x)][int(v.z)]["id"]

func set_map_p(v: Vector3, c_type: String) -> void:
	# public void SetMapP(Vector3 vP, char cType)
	map_detail[int(v.x)][int(v.z)]["type_id"] = c_type

func set_map_p_with_id(v: Vector3, c_type: String, id: int) -> void:
	# public void SetMapP(Vector3 vP, char cType, int id)
	map_detail[int(v.x)][int(v.z)]["type_id"] = c_type
	map_detail[int(v.x)][int(v.z)]["id"] = id


func remove_piece(x: int, y: int) -> void:
	# public void RemovePiece(int x, int y)
	var p_id: int = map_detail[x][y]["id"]
	if p_id != -1 and p_id < objects.size():
		if objects[p_id] != null:
			objects[p_id].queue_free()

func remove_piece_v(v: Vector3) -> void:
	# public void RemovePiece(Vector3 vP)
	remove_piece(int(v.x), int(v.z))


func replace_piece(x: int, y: int, new_type_id: String) -> void:
	# public void ReplacePiece(int x, int y, char cNewTypeID)
	var world_pos: Vector3 = grid_to_world(x, y)
	var p_id: int = map_detail[x][y]["id"]

	map_detail[x][y]["type_id"] = new_type_id

	# Replace GFX
	if p_id >= 0 and p_id < objects.size() and objects[p_id] != null:
		objects[p_id].queue_free()

	if new_type_id != "0":
		var new_piece: Node3D = PieceFactory.create_piece(new_type_id)
		if new_piece != null:
			new_piece.position = world_pos
			pieces_container.add_child(new_piece)
			if p_id >= 0 and p_id < objects.size():
				objects[p_id] = new_piece

func replace_piece_v(v: Vector3, new_type_id: String) -> void:
	# public void ReplacePiece(Vector3 vP, char cNewTypeID)
	replace_piece(int(v.x), int(v.z), new_type_id)


func move_piece(from_x: int, from_y: int, to_x: int, to_y: int) -> bool:
	# Move a piece from one grid cell to another (used for rock pushing)
	var from_type: String = map_detail[from_x][from_y]["type_id"]
	var to_type: String = map_detail[to_x][to_y]["type_id"]

	if to_type != "0":
		return false  # Destination not empty

	var piece_id: int = map_detail[from_x][from_y]["id"]

	# Update map data
	map_detail[to_x][to_y]["type_id"] = from_type
	map_detail[to_x][to_y]["id"] = piece_id
	map_detail[from_x][from_y]["type_id"] = "0"
	map_detail[from_x][from_y]["id"] = -1

	# Move the 3D object
	if piece_id >= 0 and piece_id < objects.size() and objects[piece_id] != null:
		objects[piece_id].position = grid_to_world(to_x, to_y)

	return true


func _create_border_walls() -> void:
	# Place wall pieces around the outside perimeter of the map.
	# Wall type: '5' if the adjacent interior cell is a wall, otherwise
	# edge-specific type (6=left, 4=right, 2=top, 8=bottom, corners=7/9/1/3).

	# Top + bottom rows (x from -1 to map_size_x)
	for x in range(-1, map_size_x + 1):
		_place_border_wall(x, -1)
		_place_border_wall(x, map_size_y)

	# Left + right columns (y from 0 to map_size_y - 1, corners already done)
	for y in range(map_size_y):
		_place_border_wall(-1, y)
		_place_border_wall(map_size_x, y)


func _place_border_wall(x: int, y: int) -> void:
	# Determine wall type based on edge position and adjacent level data
	var wall_type: String

	# Check the adjacent cell inside the map for a wall
	var adj_x: int = clampi(x, 0, map_size_x - 1)
	var adj_y: int = clampi(y, 0, map_size_y - 1)
	var adj_piece: String = map_detail[adj_x][adj_y]["type_id"]

	if adj_piece in ["1", "2", "3", "4", "5", "6", "7", "8", "9", "%", "&", "(", "!"]:
		wall_type = "5"
	else:
		var on_left: bool = x < 0
		var on_right: bool = x >= map_size_x
		var on_top: bool = y < 0
		var on_bottom: bool = y >= map_size_y

		if on_top and on_left:
			wall_type = "7"
		elif on_top and on_right:
			wall_type = "9"
		elif on_bottom and on_left:
			wall_type = "1"
		elif on_bottom and on_right:
			wall_type = "3"
		elif on_top:
			wall_type = "2"
		elif on_bottom:
			wall_type = "8"
		elif on_left:
			wall_type = "6"
		elif on_right:
			wall_type = "4"
		else:
			wall_type = "5"

	var world_pos: Vector3 = Vector3(x * 1.0, -y, y * MAP_SLANT)
	var piece_node: Node3D = PieceFactory.create_piece(wall_type)
	if piece_node != null:
		piece_node.position = world_pos
		piece_node.name = "border_" + wall_type + "_" + str(x) + "_" + str(y)
		pieces_container.add_child(piece_node)


func open_safes() -> void:
	# public void OpenSafes()
	for y in range(map_size_y):
		for x in range(map_size_x):
			if map_detail[x][y]["type_id"] == "s":
				replace_piece(x, y, "d")
