# level_select.gd
# Simple startup level selector — scans levels/ folder for .rrl and .rrl3d files,
# shows a button list. Emits level_selected(path) when one is picked.

class_name LevelSelect
extends Control


signal level_selected(path: String)
signal edit_new_level
signal edit_level(path: String)

const LEVELS_DIR = "res://levels/"

# Keyboard navigation
var _level_buttons: Array = []  # Array of Button (play buttons only)
var _level_paths: Array = []    # Matching paths
var _selected: int = 0


func _ready() -> void:
	# Full-screen overlay
	set_anchors_preset(Control.PRESET_FULL_RECT)

	# Dark background panel
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.15, 1.0)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	# Center container
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 80)
	margin.add_theme_constant_override("margin_bottom", 80)
	margin.add_theme_constant_override("margin_left", 200)
	margin.add_theme_constant_override("margin_right", 200)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 12)
	margin.add_child(vbox)

	# Title
	var title := Label.new()
	title.text = "REPTON RETURNS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 36)
	vbox.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Select a level"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	vbox.add_child(subtitle)

	# Spacer
	var spacer := Control.new()
	spacer.custom_minimum_size.y = 20
	vbox.add_child(spacer)

	# Scan for level files
	var levels := _scan_levels()

	if levels.is_empty():
		var no_levels := Label.new()
		no_levels.text = "No levels found in " + LEVELS_DIR
		no_levels.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(no_levels)
		return

	for level_info in levels:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		vbox.add_child(row)

		var btn := Button.new()
		btn.text = level_info["display"]
		btn.custom_minimum_size.y = 44
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.add_theme_font_size_override("font_size", 18)
		var path: String = level_info["path"]
		btn.pressed.connect(func(): _on_level_picked(path))
		row.add_child(btn)

		var idx := _level_buttons.size()
		btn.focus_entered.connect(func(): _selected = idx)
		_level_buttons.append(btn)
		_level_paths.append(path)

		# Edit button for 3D levels
		if level_info["is_3d"]:
			var edit_btn := Button.new()
			edit_btn.text = "Edit"
			edit_btn.custom_minimum_size = Vector2(70, 44)
			edit_btn.add_theme_font_size_override("font_size", 16)
			edit_btn.pressed.connect(func(): _on_edit_picked(path))
			row.add_child(edit_btn)

	# Spacer before editor button
	var spacer2 := Control.new()
	spacer2.custom_minimum_size.y = 12
	vbox.add_child(spacer2)

	# New 3D Level button
	var new_btn := Button.new()
	new_btn.text = "New 3D Level"
	new_btn.custom_minimum_size.y = 44
	new_btn.add_theme_font_size_override("font_size", 18)
	new_btn.pressed.connect(func(): edit_new_level.emit())
	vbox.add_child(new_btn)

	# Give initial focus to first level button
	if _level_buttons.size() > 0:
		_selected = 0
		_level_buttons[0].grab_focus()


func _scan_levels() -> Array:
	var results: Array = []
	var dir := DirAccess.open(LEVELS_DIR)
	if dir == null:
		push_warning("LevelSelect: Cannot open " + LEVELS_DIR)
		return results

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".rrl") or file_name.ends_with(".rrl3d"):
			var display := file_name.get_basename()
			var is_3d := file_name.ends_with(".rrl3d")
			if is_3d:
				display += "  [3D]"
			results.append({
				"path": LEVELS_DIR + file_name,
				"display": display,
				"is_3d": is_3d
			})
		file_name = dir.get_next()
	dir.list_dir_end()

	# Sort alphabetically
	results.sort_custom(func(a, b): return a["display"] < b["display"])
	return results


func _unhandled_input(event: InputEvent) -> void:
	if _level_buttons.is_empty():
		return
	if event is InputEventKey and event.pressed:
		if event.physical_keycode == KEY_UP:
			_selected = (_selected - 1 + _level_buttons.size()) % _level_buttons.size()
			_level_buttons[_selected].grab_focus()
			get_viewport().set_input_as_handled()
		elif event.physical_keycode == KEY_DOWN:
			_selected = (_selected + 1) % _level_buttons.size()
			_level_buttons[_selected].grab_focus()
			get_viewport().set_input_as_handled()
		elif event.physical_keycode == KEY_ENTER or event.physical_keycode == KEY_KP_ENTER:
			_on_level_picked(_level_paths[_selected])
			get_viewport().set_input_as_handled()


func _on_level_picked(path: String) -> void:
	level_selected.emit(path)

func _on_edit_picked(path: String) -> void:
	edit_level.emit(path)
