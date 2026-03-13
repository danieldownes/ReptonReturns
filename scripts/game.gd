# game.gd
# Repton Returns - Godot 4.6 Port
# Game orchestrator, holds references to Player and Level
# Original: Game.cs

extends Node3D


var player: Repton             # public Player playerObject;
var loaded_level               # Level or Level3D (untyped for compatibility)
var game_state: int = 0        # public int gameState; // 0 = playing, 1 = complete, 2 = game over

const LEVEL_PATH = "res://levels/Level 1.rrl"

# Camera follow settings
var camera_offset: Vector3 = Vector3(0, 3, 20)
const CAMERA_SMOOTH: float = 5.0

# 3D orbit camera
var _orbit_camera: Node3D = null
var _is_3d_level: bool = false

# Level selector UI
var _level_select: Control = null
var _level_editor: Node3D = null

# Message overlay (game over, level complete)
var _message_overlay: CanvasLayer = null

# Music
var _music: Music = null


func _ready() -> void:
	# Check command line for direct level path
	var level_path: String = ""
	var args := OS.get_cmdline_args()
	for arg in args:
		if arg.ends_with(".rrl") or arg.ends_with(".rrl3d"):
			level_path = arg

	if level_path != "":
		# Direct load from command line
		_load_and_start(level_path)
	else:
		# Show level selector
		_show_level_select()


func _show_level_select() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "LevelSelectLayer"
	add_child(canvas)

	_level_select = preload("res://scripts/level_select.gd").new()
	_level_select.name = "LevelSelect"
	_level_select.level_selected.connect(_on_level_selected)
	_level_select.edit_new_level.connect(_on_edit_new)
	_level_select.edit_level.connect(_on_edit_level)
	canvas.add_child(_level_select)


func _on_level_selected(path: String) -> void:
	if _level_select != null:
		# Remove the CanvasLayer parent too
		var canvas = _level_select.get_parent()
		if canvas:
			canvas.queue_free()
		_level_select = null
	_load_and_start(path)


func _load_and_start(level_path: String) -> void:
	# Create Level node based on file type
	if level_path.ends_with(".rrl3d"):
		var level_3d := Level3D.new()
		level_3d.name = "Level"
		level_3d.game = self
		add_child(level_3d)
		level_3d.load_file_level_3d(level_path)
		loaded_level = level_3d
		_is_3d_level = true
	else:
		var level_2d := Level.new()
		level_2d.name = "Level"
		level_2d.game = self
		add_child(level_2d)
		level_2d.load_file_level(level_path)
		loaded_level = level_2d
		_is_3d_level = false

	# Create Player
	_create_player()
	player.move_to_pos(loaded_level.start_pos)

	# Set up camera for 3D levels
	if _is_3d_level:
		_setup_orbit_camera()

	game_state = 0

	# Play startup sound
	SFX.play_global(get_tree(), SFX.startup)

	# Play random music track
	_music = Music.new()
	add_child(_music)
	_music.play_random()

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

	# Create player model from Repton.fbx, fallback to green capsule
	var fbx_node: Node3D = PieceFactory.get_repton_node()
	if fbx_node:
		fbx_node.name = "Mesh"
		fbx_node.scale = Vector3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0)
		if _is_3d_level:
			fbx_node.position.y = 0.0
		else:
			fbx_node.position.y = 0.0
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
		if _is_3d_level:
			mesh_instance.position.y = 0.0
		else:
			mesh_instance.position.y = 0.0
		player.add_child(mesh_instance)

	add_child(player)


func _process(delta: float) -> void:
	if player == null:
		return

	if game_state != 0:
		return  # Don't update camera/game if not playing

	# Camera follows player
	if _is_3d_level and _orbit_camera != null:
		_orbit_camera.update_camera(player.position, delta)
	else:
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


func _setup_orbit_camera() -> void:
	# Disable the default 2D camera
	var default_cam: Camera3D = $Camera3D
	if default_cam:
		default_cam.current = false

	# Create orbit camera
	_orbit_camera = preload("res://scripts/camera_orbit.gd").new()
	_orbit_camera.name = "OrbitCamera"
	add_child(_orbit_camera)


func _on_edit_new() -> void:
	_close_level_select()
	_open_editor("")

func _on_edit_level(path: String) -> void:
	_close_level_select()
	_open_editor(path)

func _close_level_select() -> void:
	if _level_select != null:
		var canvas = _level_select.get_parent()
		if canvas:
			canvas.queue_free()
		_level_select = null

func _open_editor(path: String) -> void:
	# Disable default camera
	var default_cam: Camera3D = $Camera3D
	if default_cam:
		default_cam.current = false

	_level_editor = preload("res://scripts/level_editor.gd").new()
	_level_editor.name = "LevelEditor"
	_level_editor.editor_closed.connect(_on_editor_closed)
	add_child(_level_editor)

	if path != "":
		_level_editor.load_level(path)

func _on_editor_closed() -> void:
	if _level_editor != null:
		_level_editor.queue_free()
		_level_editor = null

	# Re-enable default camera
	var default_cam: Camera3D = $Camera3D
	if default_cam:
		default_cam.current = true

	_show_level_select()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.physical_keycode == KEY_ESCAPE:
			# Return to level select from any state
			_return_to_level_select()
		elif event.physical_keycode == KEY_ENTER or event.physical_keycode == KEY_KP_ENTER:
			# Dismiss game over / level complete overlay
			if game_state == 1 or game_state == 2:
				_return_to_level_select()


func level_complete() -> void:
	game_state = 1
	print("LEVEL COMPLETE!")
	SFX.play_global(get_tree(), SFX.level_trans)
	_show_message("LEVEL COMPLETE!", Color(0.3, 1.0, 0.3))


func game_over() -> void:
	game_state = 2
	print("GAME OVER!")
	_show_message("GAME OVER!", Color(1.0, 0.3, 0.3))


func _show_message(text: String, color: Color) -> void:
	if _message_overlay != null:
		_message_overlay.queue_free()

	_message_overlay = CanvasLayer.new()
	_message_overlay.name = "MessageOverlay"
	add_child(_message_overlay)

	# Semi-transparent background
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.6)
	panel.add_theme_stylebox_override("panel", style)
	_message_overlay.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.add_child(vbox)

	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 48)
	label.add_theme_color_override("font_color", color)
	vbox.add_child(label)

	var hint := Label.new()
	hint.text = "Press Enter to continue"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 20)
	hint.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	vbox.add_child(hint)


func _stop_music() -> void:
	if _music != null:
		_music.stop()
		_music.queue_free()
		_music = null


func _return_to_level_select() -> void:
	# Clean up current game state
	_stop_music()

	if _message_overlay != null:
		_message_overlay.queue_free()
		_message_overlay = null

	if player != null:
		player.queue_free()
		player = null

	if loaded_level != null:
		if loaded_level is Node:
			loaded_level.queue_free()
		loaded_level = null

	if _orbit_camera != null:
		_orbit_camera.queue_free()
		_orbit_camera = null

	_is_3d_level = false
	game_state = 0

	# Re-enable default camera
	var default_cam: Camera3D = $Camera3D
	if default_cam:
		default_cam.current = true

	_show_level_select()
