# camera_orbit.gd
# Orbit camera for 3D voxel levels
# Mouse drag rotates, scroll zooms, smoothly follows player

extends Node3D


var camera: Camera3D

var orbit_distance: float = 15.0
var orbit_angle_h: float = PI / 2.0  # Horizontal angle (radians) — start behind +Z so WASD aligns with view
var orbit_angle_v: float = 0.6    # Vertical angle (radians)

const MIN_DISTANCE: float = 5.0
const MAX_DISTANCE: float = 40.0
const MIN_ANGLE_V: float = 0.1
const MAX_ANGLE_V: float = 1.4  # ~80 degrees
const ZOOM_SPEED: float = 2.0
const ROTATE_SPEED: float = 0.005
const FOLLOW_SMOOTH: float = 5.0

var _target_pos: Vector3 = Vector3.ZERO
var _is_dragging: bool = false

# Layer slice mode — hide voxels above player Y
var slice_mode: bool = false


func _ready() -> void:
	camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.fov = 50.0
	camera.current = true
	add_child(camera)

	# Register slice toggle key
	if not InputMap.has_action("toggle_slice"):
		InputMap.add_action("toggle_slice")
		var event := InputEventKey.new()
		event.physical_keycode = KEY_TAB
		InputMap.action_add_event("toggle_slice", event)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_is_dragging = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			orbit_distance = maxf(MIN_DISTANCE, orbit_distance - ZOOM_SPEED)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			orbit_distance = minf(MAX_DISTANCE, orbit_distance + ZOOM_SPEED)

	elif event is InputEventMouseMotion and _is_dragging:
		orbit_angle_h -= event.relative.x * ROTATE_SPEED
		orbit_angle_v = clampf(orbit_angle_v - event.relative.y * ROTATE_SPEED, MIN_ANGLE_V, MAX_ANGLE_V)

	elif event is InputEventKey and event.pressed:
		if event.physical_keycode == KEY_TAB:
			slice_mode = !slice_mode


func update_camera(player_pos: Vector3, delta: float) -> void:
	# Smooth follow
	_target_pos = _target_pos.lerp(player_pos, FOLLOW_SMOOTH * delta)

	# Calculate orbit position
	var offset := Vector3(
		cos(orbit_angle_h) * cos(orbit_angle_v) * orbit_distance,
		sin(orbit_angle_v) * orbit_distance,
		sin(orbit_angle_h) * cos(orbit_angle_v) * orbit_distance
	)

	camera.global_position = _target_pos + offset
	camera.look_at(_target_pos)
