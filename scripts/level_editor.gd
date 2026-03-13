# level_editor.gd
# 3D Level Editor for Repton Returns — mouse-driven
#
# Controls:
#   Left-click       — place selected piece at cursor
#   Right-click      — remove piece at cursor
#   Middle-drag      — orbit camera
#   Scroll           — zoom
#   Mouse hover      — 3D cursor follows mouse on current Y layer
#   Q / E            — change Y layer down / up
#   Ctrl+S           — save level
#   Ctrl+Z           — undo last action
#   Escape           — back to menu
#
# Left panel: clickable piece palette + tools (Save, Clear, Layer display)

extends Node3D


signal editor_closed

# Piece palette
const PALETTE: Array = [
	{"char": "5", "name": "Wall", "color": Color(0.5, 0.5, 0.5)},
	{"char": "e", "name": "Earth", "color": Color(0.55, 0.35, 0.15)},
	{"char": "d", "name": "Diamond", "color": Color(0.0, 0.9, 1.0)},
	{"char": "r", "name": "Rock", "color": Color(0.6, 0.25, 0.15)},
	{"char": "g", "name": "Egg", "color": Color(0.95, 0.95, 0.9)},
	{"char": "i", "name": "Repton", "color": Color(0.0, 0.8, 0.2)},
	{"char": "b", "name": "Bomb", "color": Color(1.0, 0.0, 0.0)},
	{"char": "m", "name": "Monster", "color": Color(0.8, 0.1, 0.1)},
	{"char": "p", "name": "Spirit", "color": Color(0.5, 0.7, 1.0)},
	{"char": "c", "name": "Cage", "color": Color(1.0, 1.0, 1.0)},
	{"char": "k", "name": "Key", "color": Color(1.0, 0.84, 0.0)},
	{"char": "s", "name": "Safe", "color": Color(0.9, 0.85, 0.2)},
	{"char": "t", "name": "Crown", "color": Color(0.7, 0.2, 0.9)},
	{"char": "n", "name": "Transport", "color": Color(0.8, 0.0, 0.8)},
	{"char": "f", "name": "Fungus", "color": Color(0.1, 0.4, 0.1)},
	{"char": "u", "name": "Skull", "color": Color(0.9, 0.9, 0.9)},
	{"char": "a", "name": "Barrier", "color": Color(0.9, 0.5, 0.1)},
	{"char": "z", "name": "TimeCap", "color": Color(0.2, 0.3, 0.9)},
	{"char": "x", "name": "MapBoard", "color": Color(0.8, 0.8, 0.8)},
]

# State
var cursor_pos: Vector3 = Vector3.ZERO
var cursor_valid: bool = false
var selected_idx: int = 0
var current_layer_y: int = 0  # The Y layer the cursor snaps to

# Placed pieces: key = "x,y,z", value = {"char": String, "node": Node3D}
var _pieces: Dictionary = {}

# Undo stack: Array of {"action": "place"/"delete", "pos_key": String, "char": String}
var _undo_stack: Array = []

# Visual
var _cursor_mesh: MeshInstance3D
var _preview_node: Node3D = null  # Ghost preview of selected piece at cursor
var _preview_char: String = ""    # Which piece char the preview is showing
var _layer_plane: MeshInstance3D  # Translucent plane showing current Y layer
var _pieces_container: Node3D

# Camera
var _camera: Camera3D
var _orbit_distance: float = 20.0
var _orbit_angle_h: float = PI / 2.0
var _orbit_angle_v: float = 0.7
var _orbit_dragging: bool = false
var _camera_target: Vector3 = Vector3(5, 0, 3)

const MIN_DISTANCE: float = 3.0
const MAX_DISTANCE: float = 80.0
const MIN_ANGLE_V: float = 0.1
const MAX_ANGLE_V: float = 1.4
const ZOOM_SPEED: float = 1.5
const ROTATE_SPEED: float = 0.005
const CAMERA_SMOOTH: float = 8.0

# UI
var _ui_layer: CanvasLayer
var _panel: PanelContainer
var _palette_buttons: Array = []  # Array of Button
var _layer_label: Label
var _pos_label: Label
var _status_label: Label
var _piece_count_label: Label

const PANEL_WIDTH: int = 160

# Metadata
var _level_name: String = "New Level"
var _save_path: String = ""

# Track if mouse is over UI panel (don't raycast)
var _mouse_over_panel: bool = false


func _ready() -> void:
	_pieces_container = Node3D.new()
	_pieces_container.name = "EditorPieces"
	add_child(_pieces_container)

	_create_cursor()
	_create_layer_plane()
	_create_camera()
	_create_ui()

	# Register Q/E for layer change
	_register_key_action("editor_y_up", KEY_E)
	_register_key_action("editor_y_down", KEY_Q)
	_register_key_action("editor_escape", KEY_ESCAPE)


func _register_key_action(action_name: String, key: int) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
		var event := InputEventKey.new()
		event.physical_keycode = key
		InputMap.action_add_event(action_name, event)


func _create_cursor() -> void:
	_cursor_mesh = MeshInstance3D.new()
	_cursor_mesh.name = "Cursor"
	var box := BoxMesh.new()
	box.size = Vector3(1.02, 1.02, 1.02)
	_cursor_mesh.mesh = box

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 1.0, 0.0, 0.3)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	_cursor_mesh.material_override = mat
	_cursor_mesh.visible = false

	add_child(_cursor_mesh)


func _create_layer_plane() -> void:
	# Faint grid plane showing current Y layer
	_layer_plane = MeshInstance3D.new()
	_layer_plane.name = "LayerPlane"
	var plane := PlaneMesh.new()
	plane.size = Vector2(100, 100)
	_layer_plane.mesh = plane

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.3, 0.5, 1.0, 0.06)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	_layer_plane.material_override = mat
	_layer_plane.position.y = float(current_layer_y) + 0.5

	add_child(_layer_plane)


func _create_camera() -> void:
	_camera = Camera3D.new()
	_camera.name = "EditorCamera"
	_camera.fov = 50.0
	_camera.current = true
	add_child(_camera)
	_update_camera()


func _create_ui() -> void:
	_ui_layer = CanvasLayer.new()
	_ui_layer.name = "EditorUI"
	add_child(_ui_layer)

	# Left panel
	_panel = PanelContainer.new()
	_panel.position = Vector2(0, 0)
	_panel.custom_minimum_size = Vector2(PANEL_WIDTH, 0)
	_panel.set_anchors_preset(Control.PRESET_LEFT_WIDE)
	_panel.size.x = PANEL_WIDTH
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.12, 0.12, 0.16, 0.9)
	_panel.add_theme_stylebox_override("panel", panel_style)
	_panel.mouse_entered.connect(func(): _mouse_over_panel = true)
	_panel.mouse_exited.connect(func(): _mouse_over_panel = false)
	_ui_layer.add_child(_panel)

	var scroll := ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panel.add_child(scroll)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(vbox)

	# Title
	var title := Label.new()
	title.text = "EDITOR"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 16)
	vbox.add_child(title)

	# Layer controls
	var layer_row := HBoxContainer.new()
	layer_row.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(layer_row)

	var layer_down_btn := Button.new()
	layer_down_btn.text = "-"
	layer_down_btn.custom_minimum_size = Vector2(30, 30)
	layer_down_btn.pressed.connect(func(): _change_layer(-1))
	layer_row.add_child(layer_down_btn)

	_layer_label = Label.new()
	_layer_label.text = "Y: 0"
	_layer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_layer_label.custom_minimum_size = Vector2(60, 0)
	_layer_label.add_theme_font_size_override("font_size", 14)
	layer_row.add_child(_layer_label)

	var layer_up_btn := Button.new()
	layer_up_btn.text = "+"
	layer_up_btn.custom_minimum_size = Vector2(30, 30)
	layer_up_btn.pressed.connect(func(): _change_layer(1))
	layer_row.add_child(layer_up_btn)

	# Separator
	var sep := HSeparator.new()
	vbox.add_child(sep)

	# Piece palette buttons
	for i in range(PALETTE.size()):
		var btn := Button.new()
		btn.text = PALETTE[i]["name"]
		btn.custom_minimum_size = Vector2(0, 28)
		btn.add_theme_font_size_override("font_size", 12)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var idx := i
		btn.pressed.connect(func(): _select_piece(idx))
		vbox.add_child(btn)
		_palette_buttons.append(btn)

	_update_palette_highlight()

	# Separator
	var sep2 := HSeparator.new()
	vbox.add_child(sep2)

	# Tool buttons
	var save_btn := Button.new()
	save_btn.text = "Save (Ctrl+S)"
	save_btn.custom_minimum_size = Vector2(0, 32)
	save_btn.add_theme_font_size_override("font_size", 12)
	save_btn.pressed.connect(func(): _save_level())
	vbox.add_child(save_btn)

	var clear_btn := Button.new()
	clear_btn.text = "Clear All"
	clear_btn.custom_minimum_size = Vector2(0, 32)
	clear_btn.add_theme_font_size_override("font_size", 12)
	clear_btn.pressed.connect(func(): _new_level())
	vbox.add_child(clear_btn)

	var back_btn := Button.new()
	back_btn.text = "Back (Esc)"
	back_btn.custom_minimum_size = Vector2(0, 32)
	back_btn.add_theme_font_size_override("font_size", 12)
	back_btn.pressed.connect(func(): editor_closed.emit())
	vbox.add_child(back_btn)

	# Bottom info bar
	_pos_label = Label.new()
	_pos_label.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	_pos_label.position = Vector2(PANEL_WIDTH + 10, -30)
	_pos_label.add_theme_font_size_override("font_size", 14)
	_pos_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	_ui_layer.add_child(_pos_label)

	_piece_count_label = Label.new()
	_piece_count_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	_piece_count_label.position = Vector2(-160, -30)
	_piece_count_label.add_theme_font_size_override("font_size", 14)
	_piece_count_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	_piece_count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_piece_count_label.custom_minimum_size.x = 150
	_ui_layer.add_child(_piece_count_label)

	_status_label = Label.new()
	_status_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_status_label.position = Vector2(-250, 16)
	_status_label.add_theme_font_size_override("font_size", 16)
	_status_label.add_theme_color_override("font_color", Color(0.3, 1.0, 0.3))
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_status_label.custom_minimum_size.x = 240
	_ui_layer.add_child(_status_label)


func _process(delta: float) -> void:
	# Layer change with keys
	if Input.is_action_just_pressed("editor_y_up"):
		_change_layer(1)
	if Input.is_action_just_pressed("editor_y_down"):
		_change_layer(-1)
	if Input.is_action_just_pressed("editor_escape"):
		editor_closed.emit()
		return

	# Raycast mouse position to get cursor grid cell
	_update_cursor_from_mouse()

	# Smooth camera
	_update_camera()

	# Status fade
	if _status_label.modulate.a > 0:
		_status_label.modulate.a -= delta * 0.4

	# Info
	_update_info()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not _mouse_over_panel and cursor_valid:
				_place_piece()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if not _mouse_over_panel and cursor_valid:
				_delete_piece()
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			_orbit_dragging = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			if event.shift_pressed:
				_orbit_distance = maxf(MIN_DISTANCE, _orbit_distance - ZOOM_SPEED)
			else:
				_change_layer_keep_cursor(1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			if event.shift_pressed:
				_orbit_distance = minf(MAX_DISTANCE, _orbit_distance + ZOOM_SPEED)
			else:
				_change_layer_keep_cursor(-1)

	elif event is InputEventMouseMotion and _orbit_dragging:
		_orbit_angle_h -= event.relative.x * ROTATE_SPEED
		_orbit_angle_v = clampf(_orbit_angle_v - event.relative.y * ROTATE_SPEED, MIN_ANGLE_V, MAX_ANGLE_V)

	# Ctrl+S
	if event is InputEventKey and event.pressed and event.ctrl_pressed:
		if event.physical_keycode == KEY_S:
			_save_level()
		elif event.physical_keycode == KEY_Z:
			_undo()


func _update_cursor_from_mouse() -> void:
	# Raycast from camera through mouse position onto the Y=current_layer_y+0.5 plane
	if _camera == null:
		return

	var viewport := get_viewport()
	if viewport == null:
		return

	var mouse_pos: Vector2 = viewport.get_mouse_position()

	# Don't raycast if over panel
	if mouse_pos.x < PANEL_WIDTH:
		_cursor_mesh.visible = false
		_hide_preview()
		cursor_valid = false
		return

	var ray_origin: Vector3 = _camera.project_ray_origin(mouse_pos)
	var ray_dir: Vector3 = _camera.project_ray_normal(mouse_pos)

	# Intersect with horizontal plane at y = current_layer_y + 0.5 (center of cells)
	var plane_y: float = float(current_layer_y) + 0.5
	if abs(ray_dir.y) < 0.001:
		_cursor_mesh.visible = false
		_hide_preview()
		cursor_valid = false
		return

	var t: float = (plane_y - ray_origin.y) / ray_dir.y
	if t < 0:
		_cursor_mesh.visible = false
		_hide_preview()
		cursor_valid = false
		return

	var hit: Vector3 = ray_origin + ray_dir * t

	# Snap to grid
	cursor_pos = Vector3(floor(hit.x + 0.5), current_layer_y, floor(hit.z + 0.5))
	# Offset cursor mesh +0.5 Y to match piece mesh offset inside their nodes
	_cursor_mesh.position = cursor_pos + Vector3(0, 0.5, 0)
	_cursor_mesh.visible = true
	cursor_valid = true

	# Update ghost preview
	_update_preview()


func _update_camera() -> void:
	var offset := Vector3(
		cos(_orbit_angle_h) * cos(_orbit_angle_v) * _orbit_distance,
		sin(_orbit_angle_v) * _orbit_distance,
		sin(_orbit_angle_h) * cos(_orbit_angle_v) * _orbit_distance
	)
	_camera.global_position = _camera_target + offset
	_camera.look_at(_camera_target)


func _update_preview() -> void:
	var piece_char: String = PALETTE[selected_idx]["char"]

	# Rebuild preview if piece selection changed
	if piece_char != _preview_char:
		_hide_preview()
		_preview_char = piece_char
		_preview_node = PieceFactory.create_piece(piece_char, true)
		if _preview_node:
			_preview_node.name = "Preview"
			_set_transparent(_preview_node, 0.5)
			add_child(_preview_node)

	if _preview_node:
		_preview_node.position = cursor_pos
		_preview_node.visible = true


func _hide_preview() -> void:
	if _preview_node != null:
		_preview_node.visible = false


func _set_transparent(node: Node, alpha: float) -> void:
	if node is MeshInstance3D:
		var mi: MeshInstance3D = node
		var mat = mi.material_override
		if mat == null and mi.mesh != null:
			mat = mi.mesh.surface_get_material(0)
		if mat is StandardMaterial3D:
			var new_mat: StandardMaterial3D = mat.duplicate()
			new_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			new_mat.albedo_color.a = alpha
			mi.material_override = new_mat
		elif mat == null:
			var new_mat := StandardMaterial3D.new()
			new_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			new_mat.albedo_color = Color(1, 1, 1, alpha)
			mi.material_override = new_mat
	for child in node.get_children():
		_set_transparent(child, alpha)


func _update_info() -> void:
	if cursor_valid:
		var k := _pos_key(cursor_pos)
		var info: String = str(int(cursor_pos.x)) + ", " + str(int(cursor_pos.y)) + ", " + str(int(cursor_pos.z))
		if _pieces.has(k):
			var c: String = _pieces[k]["char"]
			for p in PALETTE:
				if p["char"] == c:
					info += "  [" + p["name"] + "]"
					break
		_pos_label.text = info
	else:
		_pos_label.text = ""

	_piece_count_label.text = "Pieces: " + str(_pieces.size())


func _select_piece(idx: int) -> void:
	selected_idx = idx
	_update_palette_highlight()
	# Force preview rebuild on next cursor update
	if _preview_node != null:
		_preview_node.queue_free()
		_preview_node = null
		_preview_char = ""


func _update_palette_highlight() -> void:
	for i in range(_palette_buttons.size()):
		var btn: Button = _palette_buttons[i]
		if i == selected_idx:
			var style := StyleBoxFlat.new()
			style.bg_color = PALETTE[i]["color"] * 0.6
			style.bg_color.a = 0.8
			style.border_color = Color(1, 1, 0)
			style.set_border_width_all(2)
			style.set_content_margin_all(4)
			btn.add_theme_stylebox_override("normal", style)
			btn.add_theme_stylebox_override("hover", style)
			btn.add_theme_stylebox_override("pressed", style)
		else:
			# Color swatch style
			var style := StyleBoxFlat.new()
			style.bg_color = PALETTE[i]["color"] * 0.3
			style.bg_color.a = 0.5
			style.set_content_margin_all(4)
			btn.add_theme_stylebox_override("normal", style)
			var hover_style := StyleBoxFlat.new()
			hover_style.bg_color = PALETTE[i]["color"] * 0.4
			hover_style.bg_color.a = 0.6
			hover_style.set_content_margin_all(4)
			btn.add_theme_stylebox_override("hover", hover_style)
			btn.add_theme_stylebox_override("pressed", style)


func _change_layer(dir: int) -> void:
	current_layer_y += dir
	_layer_label.text = "Y: " + str(current_layer_y)
	_layer_plane.position.y = float(current_layer_y) + 0.5
	_show_status("Layer: " + str(current_layer_y))


func _change_layer_keep_cursor(dir: int) -> void:
	# Change layer but keep cursor at same X/Z position (only Y changes)
	var old_x: float = cursor_pos.x
	var old_z: float = cursor_pos.z
	_change_layer(dir)
	if cursor_valid:
		cursor_pos = Vector3(old_x, current_layer_y, old_z)
		_cursor_mesh.position = cursor_pos + Vector3(0, 0.5, 0)
		if _preview_node:
			_preview_node.position = cursor_pos


func _count_pieces(piece_char: String) -> int:
	var count := 0
	for pk in _pieces:
		if _pieces[pk]["char"] == piece_char:
			count += 1
	return count


func _find_piece(piece_char: String) -> String:
	# Returns the pos_key of the first piece matching piece_char, or ""
	for pk in _pieces:
		if _pieces[pk]["char"] == piece_char:
			return pk
	return ""


func _remove_piece_at_key(pos_key: String) -> void:
	if _pieces.has(pos_key):
		if _pieces[pos_key]["node"] != null:
			_pieces[pos_key]["node"].queue_free()
		_pieces.erase(pos_key)


func _place_piece() -> void:
	var k := _pos_key(cursor_pos)
	var piece_char: String = PALETTE[selected_idx]["char"]
	var old_char: String = ""

	# Singleton pieces: remove existing one when placing a new one
	if piece_char == "i" or piece_char == "b":
		var existing_key := _find_piece(piece_char)
		if existing_key != "" and existing_key != k:
			var existing_char: String = _pieces[existing_key]["char"]
			var p = existing_key.split(",")
			var existing_pos := Vector3(int(p[0]), int(p[1]), int(p[2]))
			_undo_stack.append({"action": "place", "pos_key": existing_key, "old_char": existing_char, "new_char": "", "pos": existing_pos})
			_remove_piece_at_key(existing_key)

	# Track undo
	if _pieces.has(k):
		old_char = _pieces[k]["char"]
		if _pieces[k]["node"] != null:
			_pieces[k]["node"].queue_free()
		_pieces.erase(k)

	_undo_stack.append({"action": "place", "pos_key": k, "old_char": old_char, "new_char": piece_char, "pos": cursor_pos})

	var piece_node: Node3D = PieceFactory.create_piece(piece_char, true)
	if piece_node != null:
		piece_node.position = cursor_pos
		piece_node.name = piece_char + "_" + k
		_pieces_container.add_child(piece_node)

	_pieces[k] = {"char": piece_char, "node": piece_node}

	# Warnings
	var status_msg: String = "Placed: " + PALETTE[selected_idx]["name"]
	if piece_char == "s" and _count_pieces("k") == 0:
		status_msg += "  [No keys in level!]"
	if piece_char == "p" or piece_char == "c":
		var spirits := _count_pieces("p")
		var cages := _count_pieces("c")
		if spirits != cages:
			status_msg += "  [Spirits: " + str(spirits) + " != Cages: " + str(cages) + "]"

	_show_status(status_msg)


func _delete_piece() -> void:
	var k := _pos_key(cursor_pos)
	if _pieces.has(k):
		var old_char: String = _pieces[k]["char"]
		_undo_stack.append({"action": "delete", "pos_key": k, "old_char": old_char, "new_char": "", "pos": cursor_pos})
		if _pieces[k]["node"] != null:
			_pieces[k]["node"].queue_free()
		_pieces.erase(k)

		var status_msg: String = "Deleted"
		if old_char == "p" or old_char == "c":
			var spirits := _count_pieces("p")
			var cages := _count_pieces("c")
			if spirits != cages:
				status_msg += "  [Spirits: " + str(spirits) + " != Cages: " + str(cages) + "]"
		_show_status(status_msg)


func _undo() -> void:
	if _undo_stack.is_empty():
		_show_status("Nothing to undo")
		return

	var entry: Dictionary = _undo_stack.pop_back()
	var k: String = entry["pos_key"]
	var pos: Vector3 = entry["pos"]

	# Remove whatever is currently at that position
	if _pieces.has(k):
		if _pieces[k]["node"] != null:
			_pieces[k]["node"].queue_free()
		_pieces.erase(k)

	# Restore old state
	if entry["old_char"] != "":
		var piece_node: Node3D = PieceFactory.create_piece(entry["old_char"], true)
		if piece_node != null:
			piece_node.position = pos
			piece_node.name = entry["old_char"] + "_" + k
			_pieces_container.add_child(piece_node)
		_pieces[k] = {"char": entry["old_char"], "node": piece_node}

	_show_status("Undo")


func _show_status(msg: String) -> void:
	_status_label.text = msg
	_status_label.modulate.a = 1.0


func _pos_key(v: Vector3) -> String:
	return str(int(v.x)) + "," + str(int(v.y)) + "," + str(int(v.z))


# === Save / Load ===

func _save_level() -> void:
	if _pieces.is_empty():
		_show_status("Nothing to save")
		return

	if _save_path == "":
		var idx := 1
		while true:
			var candidate: String = "res://levels/Level3D " + str(idx) + ".rrl3d"
			if not FileAccess.file_exists(candidate):
				_save_path = candidate
				_level_name = "Level3D " + str(idx)
				break
			idx += 1

	var file := FileAccess.open(_save_path, FileAccess.WRITE)
	if file == null:
		_show_status("Error: Cannot write")
		return

	file.store_line("ReptonReturnsLevel3DV1.0")
	file.store_line(_level_name)
	file.store_line("-1")
	file.store_line("---PIECES---")

	var keys = _pieces.keys()
	keys.sort()
	for k in keys:
		file.store_line(k + "," + _pieces[k]["char"])

	file.store_line("---TRANSPORTERS---")
	file.store_line("---COLOURKEYS---")
	file.store_line("---END---")

	file.close()
	_show_status("Saved: " + _save_path)


func _new_level() -> void:
	for k in _pieces.keys():
		if _pieces[k]["node"] != null:
			_pieces[k]["node"].queue_free()
	_pieces.clear()
	_undo_stack.clear()
	cursor_pos = Vector3.ZERO
	current_layer_y = 0
	_layer_label.text = "Y: 0"
	_layer_plane.position.y = 0.5
	_save_path = ""
	_level_name = "New Level"
	_show_status("Cleared")


func load_level(file_path: String) -> void:
	_new_level()
	_save_path = file_path
	_level_name = file_path.get_file().get_basename()

	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		_show_status("Cannot open file")
		return

	file.get_line()  # version
	_level_name = file.get_line()
	file.get_line()  # time

	var section: String = ""
	while not file.eof_reached():
		var line: String = file.get_line().strip_edges()
		if line == "":
			continue
		if line.begins_with("---"):
			section = line
			continue
		if section == "---PIECES---":
			var parts = line.split(",")
			if parts.size() >= 4:
				var pos := Vector3(int(parts[0]), int(parts[1]), int(parts[2]))
				var c: String = parts[3]
				var k := _pos_key(pos)

				var piece_node: Node3D = PieceFactory.create_piece(c, true)
				if piece_node != null:
					piece_node.position = pos
					piece_node.name = c + "_" + k
					_pieces_container.add_child(piece_node)
				_pieces[k] = {"char": c, "node": piece_node}
		elif section == "---END---":
			break

	file.close()

	# Center camera on level
	if not _pieces.is_empty():
		var center := Vector3.ZERO
		var count := 0
		for k in _pieces.keys():
			var p = k.split(",")
			center += Vector3(int(p[0]), int(p[1]), int(p[2]))
			count += 1
		center /= float(count)
		_camera_target = center

	_show_status("Loaded: " + _level_name)
