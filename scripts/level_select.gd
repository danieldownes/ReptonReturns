# level_select.gd
# Repton Returns - Godot 4.6 Port
# Multi-screen level selector with Play 2D, Play 3D, Level Editor menus

class_name LevelSelect
extends Control


signal level_selected(path: String)
signal edit_new_level
signal edit_level(path: String)

const LEVELS_DIR = "res://levels/"
const R3_LEVELS_DIR = "res://levels/r3levels/"
const LEVEL_PACKS_2D: Array = ["Prelude", "Toccata", "Finale"]

var _content_container: VBoxContainer = null
var _back_stack: Array = []  # Stack of callables to rebuild previous screen


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_root_menu()


func _build_shell() -> VBoxContainer:
	# Clear existing children
	for child in get_children():
		child.queue_free()

	# Dark background panel
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.15, 1.0)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	# Margin
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 80)
	margin.add_theme_constant_override("margin_bottom", 80)
	margin.add_theme_constant_override("margin_left", 200)
	margin.add_theme_constant_override("margin_right", 200)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	vbox.add_theme_constant_override("separation", 12)
	margin.add_child(vbox)

	# Title
	var title := Label.new()
	title.text = "REPTON RETURNS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 36)
	vbox.add_child(title)

	_content_container = vbox
	return vbox


func _add_subtitle(vbox: VBoxContainer, text: String) -> void:
	var subtitle := Label.new()
	subtitle.text = text
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	vbox.add_child(subtitle)


func _add_spacer(vbox: VBoxContainer, height: float = 20.0) -> void:
	var spacer := Control.new()
	spacer.custom_minimum_size.y = height
	vbox.add_child(spacer)


func _add_button(vbox: VBoxContainer, text: String, callback: Callable) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size.y = 44
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.add_theme_font_size_override("font_size", 18)
	btn.pressed.connect(callback)
	vbox.add_child(btn)
	return btn


func _add_back_button(vbox: VBoxContainer) -> void:
	_add_spacer(vbox, 12)
	var btn := _add_button(vbox, "Back", _go_back)
	btn.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))


# === Root Menu ===

func _build_root_menu() -> void:
	var vbox := _build_shell()
	_add_spacer(vbox)

	var first_btn := _add_button(vbox, "Play 2D", _show_play_2d)
	_add_button(vbox, "Play 3D", _show_play_3d)
	_add_spacer(vbox, 12)
	_add_button(vbox, "Level Editor", _show_editor_menu)

	first_btn.call_deferred("grab_focus")


# === Play 2D: Level Pack Selection ===

func _show_play_2d() -> void:
	_back_stack.append(_build_root_menu)
	var vbox := _build_shell()
	_add_subtitle(vbox, "Select Level Pack")
	_add_spacer(vbox)

	var first_btn: Button = null
	for pack_name in LEVEL_PACKS_2D:
		var captured_name: String = pack_name
		var btn := _add_button(vbox, pack_name, func(): _show_pack_levels(captured_name))
		if first_btn == null:
			first_btn = btn

	_add_back_button(vbox)
	if first_btn:
		first_btn.call_deferred("grab_focus")


# === Play 2D: Level List for a Pack ===

func _show_pack_levels(pack_name: String) -> void:
	print("LevelSelect: Opening pack: ", pack_name)
	_back_stack.append(_show_play_2d)
	var vbox := _build_shell()
	_add_subtitle(vbox, pack_name)
	_add_spacer(vbox)

	var pack_dir: String = R3_LEVELS_DIR + pack_name + "/"
	print("LevelSelect: Scanning directory: ", pack_dir)
	var levels := _scan_dir_for_ext(pack_dir, ".rrl")

	if levels.is_empty():
		var lbl := Label.new()
		lbl.text = "No levels found"
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(lbl)
	else:
		var first_btn: Button = null
		for info in levels:
			var path: String = info["path"]
			var btn := _add_button(vbox, info["display"], func(): _on_level_picked(path))
			if first_btn == null:
				first_btn = btn

		if first_btn:
			first_btn.call_deferred("grab_focus")

	_add_back_button(vbox)


# === Play 3D ===

func _show_play_3d() -> void:
	_back_stack.append(_build_root_menu)
	var vbox := _build_shell()
	_add_subtitle(vbox, "3D Levels")
	_add_spacer(vbox)

	var levels := _scan_dir_for_ext(LEVELS_DIR, ".rrl3d")

	if levels.is_empty():
		var lbl := Label.new()
		lbl.text = "No 3D levels found"
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(lbl)
	else:
		var first_btn: Button = null
		for info in levels:
			var path: String = info["path"]
			var row := HBoxContainer.new()
			row.add_theme_constant_override("separation", 8)
			vbox.add_child(row)

			var btn := Button.new()
			btn.text = info["display"]
			btn.custom_minimum_size.y = 44
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.add_theme_font_size_override("font_size", 18)
			btn.pressed.connect(func(): _on_level_picked(path))
			row.add_child(btn)
			if first_btn == null:
				first_btn = btn

			# Edit button
			var edit_btn := Button.new()
			edit_btn.text = "Edit"
			edit_btn.custom_minimum_size = Vector2(70, 44)
			edit_btn.add_theme_font_size_override("font_size", 16)
			edit_btn.pressed.connect(func(): _on_edit_picked(path))
			row.add_child(edit_btn)

		if first_btn:
			first_btn.call_deferred("grab_focus")

	_add_back_button(vbox)


# === Level Editor Menu ===

func _show_editor_menu() -> void:
	_back_stack.append(_build_root_menu)
	var vbox := _build_shell()
	_add_subtitle(vbox, "Level Editor")
	_add_spacer(vbox)

	var first_btn := _add_button(vbox, "New 3D Level", func(): edit_new_level.emit())

	# List existing 3D levels for editing
	var levels := _scan_dir_for_ext(LEVELS_DIR, ".rrl3d")
	if not levels.is_empty():
		_add_spacer(vbox, 12)
		var lbl := Label.new()
		lbl.text = "Edit Existing:"
		lbl.add_theme_font_size_override("font_size", 16)
		lbl.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
		vbox.add_child(lbl)

		for info in levels:
			var path: String = info["path"]
			_add_button(vbox, info["display"], func(): _on_edit_picked(path))

	_add_back_button(vbox)
	first_btn.call_deferred("grab_focus")


# === Navigation ===

func _go_back() -> void:
	if _back_stack.size() > 0:
		var prev: Callable = _back_stack.pop_back()
		prev.call()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.physical_keycode == KEY_ESCAPE:
			if _back_stack.size() > 0:
				_go_back()
				get_viewport().set_input_as_handled()


# === Scanning ===

func _scan_dir_for_ext(dir_path: String, ext: String) -> Array:
	var results: Array = []

	# Try res:// path first, then fall back to globalized (absolute) path
	var dir := DirAccess.open(dir_path)
	if dir == null:
		# Try absolute path
		var abs_path: String = ProjectSettings.globalize_path(dir_path)
		dir = DirAccess.open(abs_path)
	if dir == null:
		push_warning("LevelSelect: Cannot open directory: " + dir_path)
		return results

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with(ext):
				results.append({
					"path": dir_path + file_name,
					"display": file_name.get_basename()
				})
		file_name = dir.get_next()
	dir.list_dir_end()
	print("LevelSelect: Scanned ", dir_path, " for *", ext, " — found ", results.size())

	results.sort_custom(func(a, b): return a["display"] < b["display"])
	return results


# === Callbacks ===

func _on_level_picked(path: String) -> void:
	level_selected.emit(path)

func _on_edit_picked(path: String) -> void:
	edit_level.emit(path)
