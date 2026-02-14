# game.gd
# Repton Returns - Godot 4.6 Port
# Game orchestrator, holds references to Player and Level
# Original: Game.cs

extends Node3D


var player: Repton             # public Player playerObject;
var loaded_level: Level        # public Level loadedLevel;
var game_state: int = 0        # public int gameState; // 0 = playing, 1 = complete, 2 = game over

const LEVEL_PATH = "res://levels/Level 1.rrl"

# Camera follow settings
var camera_offset: Vector3 = Vector3(0, 3, 20)
const CAMERA_SMOOTH: float = 5.0


func _ready() -> void:
	# void Start()

	# Create Level node
	loaded_level = Level.new()
	loaded_level.name = "Level"
	loaded_level.game = self
	add_child(loaded_level)

	# Load the level
	loaded_level.load_file_level(LEVEL_PATH)

	# Create Player
	_create_player()

	# playerObject.MoveToPos(loadedLevel.vStartPos);
	player.move_to_pos(loaded_level.start_pos)

	print("Player start position: ", loaded_level.start_pos)
	print("Objectives — Diamonds:", loaded_level.diamonds,
		" Crowns:", loaded_level.crowns,
		" Eggs:", loaded_level.eggs,
		" Monsters:", loaded_level.monsters_alive,
		" Spirits:", loaded_level.spirits)


func _create_player() -> void:
	player = Repton.new()
	player.name = "Player"
	player.level = loaded_level

	# Create player model from FBX (full subtree with sub-meshes + animation),
	# fallback to green capsule
	var fbx_node: Node3D = PieceFactory.get_fbx_node("i")
	if fbx_node:
		fbx_node.name = "Mesh"
		fbx_node.scale = PieceFactory.FBX_SCALE
		fbx_node.position.y = 0.5
		player.add_child(fbx_node)
	else:
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.name = "Mesh"
		var capsule := CapsuleMesh.new()
		capsule.radius = 0.3
		capsule.height = 0.8
		var material := StandardMaterial3D.new()
		material.albedo_color = Color(0.0, 0.8, 0.2)
		mesh_instance.mesh = capsule
		mesh_instance.material_override = material
		mesh_instance.position.y = 0.4
		player.add_child(mesh_instance)

	add_child(player)


func _process(delta: float) -> void:
	if player == null:
		return

	if game_state != 0:
		return  # Don't update camera/game if not playing

	# Camera follows player
	var camera: Camera3D = $Camera3D
	if camera:
		var target_pos: Vector3 = player.position + camera_offset
		camera.position = camera.position.lerp(target_pos, CAMERA_SMOOTH * delta)
		camera.look_at(player.position)

	# Time bomb countdown
	if loaded_level != null and loaded_level.time_bomb > 0:
		loaded_level.time_bomb -= delta
		if loaded_level.time_bomb <= 0:
			# Time's up — player dies
			loaded_level.time_bomb = 0
			player.die()


func level_complete() -> void:
	game_state = 1
	print("LEVEL COMPLETE!")


func game_over() -> void:
	game_state = 2
	print("GAME OVER!")
