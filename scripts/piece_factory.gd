# piece_factory.gd
# Repton Returns - Godot 4.6 Port
# Factory for creating piece meshes using FBX models where available,
# falling back to primitive shapes for pieces without FBX models

class_name PieceFactory


const FBX_PATH = "res://models/ReptonReturnsFbx.fbx"
const REPTON_FBX_PATH = "res://models/Repton.fbx"

# Maps piece type characters to FBX node names (in ReptonReturnsFbx.fbx)
const FBX_MODEL_MAP: Dictionary = {
	"b": "Bomb",
	"c": "Cage",
	"d": "Diamond",
	"g": "Egg",
	"k": "Key",
	"C": "Key",        # ColourKey uses Key model
	"x": "MessageBoard",
	"m": "Monster",
	"r": "Rock",
	"t": "TheCrown",
	"z": "TimeCapsule",
}

# Cached node subtrees duplicated from FBX (templates, not in scene tree)
static var _fbx_templates: Dictionary = {}
static var _fbx_loaded: bool = false

# Cached Repton model from separate FBX
static var _repton_template: Node3D = null
static var _repton_loaded: bool = false


# Color palette for piece types (used for primitive fallbacks)
const COLORS: Dictionary = {
	"5": Color(0.5, 0.5, 0.5),       # Wall - gray
	"1": Color(0.45, 0.45, 0.45),    # Wall variant
	"2": Color(0.5, 0.5, 0.5),       # Wall variant
	"3": Color(0.45, 0.45, 0.45),    # Wall variant
	"4": Color(0.5, 0.5, 0.5),       # Wall variant
	"6": Color(0.48, 0.48, 0.48),    # Wall variant
	"7": Color(0.45, 0.45, 0.45),    # Wall variant
	"8": Color(0.48, 0.48, 0.48),    # Wall variant
	"9": Color(0.52, 0.52, 0.52),    # Wall variant
	"%": Color(0.35, 0.35, 0.35),    # FilledWall - dark gray
	"&": Color(0.35, 0.35, 0.35),    # FilledWall7
	"(": Color(0.35, 0.35, 0.35),    # FilledWall9
	"!": Color(0.35, 0.35, 0.35),    # FilledWall1
	"e": Color(0.55, 0.35, 0.15),    # Earth - brown
	"d": Color(0.0, 0.9, 1.0),       # Diamond - cyan
	"r": Color(0.6, 0.25, 0.15),     # Rock - dark red
	"i": Color(0.0, 0.8, 0.2),       # Player/Repton - green
	"s": Color(0.9, 0.85, 0.2),      # Safe - yellow
	"k": Color(1.0, 0.84, 0.0),      # Key - gold
	"g": Color(0.95, 0.95, 0.9),     # Egg - white
	"t": Color(0.7, 0.2, 0.9),       # Crown - purple
	"c": Color(1.0, 1.0, 1.0),       # Cage - white
	"p": Color(0.5, 0.7, 1.0),       # Spirit - light blue
	"b": Color(1.0, 0.0, 0.0),       # Bomb - red
	"f": Color(0.1, 0.4, 0.1),       # Fungus - dark green
	"u": Color(1.0, 1.0, 1.0),       # Skull - white
	"a": Color(0.9, 0.5, 0.1),       # Barrier - orange
	"m": Color(0.8, 0.1, 0.1),       # Monster - red
	"n": Color(0.8, 0.0, 0.8),       # Transporter - magenta
	"z": Color(0.2, 0.3, 0.9),       # TimeCapsule - blue
	"x": Color(0.8, 0.8, 0.8),       # Map - light gray
	"y": Color(1.0, 1.0, 1.0),       # LevelTransport - white
	"C": Color(0.9, 0.9, 0.0),       # ColourKey - yellow (base)
	"D": Color(0.9, 0.9, 0.0),       # Door - yellow (base)
}

const WALL_CHARS: Array = ["5", "1", "2", "3", "4", "6", "7", "8", "9", "%", "&", "(", "!", "a"]


static func _ensure_fbx_loaded() -> void:
	if _fbx_loaded:
		return
	_fbx_loaded = true

	var fbx_scene: PackedScene = load(FBX_PATH)
	if fbx_scene == null:
		push_warning("PieceFactory: Could not load FBX at " + FBX_PATH)
		return

	var instance = fbx_scene.instantiate()

	# Track which model names we've already duplicated (for shared models like Key)
	var duplicated_models: Dictionary = {}

	for type_char in FBX_MODEL_MAP:
		var model_name: String = FBX_MODEL_MAP[type_char]
		if model_name in duplicated_models:
			_fbx_templates[type_char] = duplicated_models[model_name]
			continue
		var source_node = _find_node(instance, model_name)
		if source_node:
			var template = source_node.duplicate()
			_fbx_templates[type_char] = template
			duplicated_models[model_name] = template
		else:
			push_warning("PieceFactory: FBX node '" + model_name + "' not found for type '" + type_char + "'")

	instance.free()
	print("PieceFactory: Loaded ", _fbx_templates.size(), " models from FBX")


static func _ensure_repton_loaded() -> void:
	if _repton_loaded:
		return
	_repton_loaded = true

	var fbx_scene: PackedScene = load(REPTON_FBX_PATH)
	if fbx_scene == null:
		push_warning("PieceFactory: Could not load Repton FBX at " + REPTON_FBX_PATH)
		return

	var instance = fbx_scene.instantiate()
	_repton_template = instance
	print("PieceFactory: Loaded Repton model from ", REPTON_FBX_PATH)


static func _find_node(parent: Node, target_name: String) -> Node:
	for child in parent.get_children():
		if child.name == target_name:
			return child
		var result = _find_node(child, target_name)
		if result:
			return result
	return null


static func get_fbx_node(type_char: String) -> Node3D:
	_ensure_fbx_loaded()
	var template = _fbx_templates.get(type_char)
	if template:
		return template.duplicate()
	return null


static func get_repton_node() -> Node3D:
	_ensure_repton_loaded()
	if _repton_template:
		return _repton_template.duplicate()
	return null


static func create_piece(type_char: String, is_3d: bool = false) -> Node3D:
	if type_char == "0":
		return null

	_ensure_fbx_loaded()

	# Active pieces get their own typed nodes so _process() runs
	var node: Node3D
	match type_char:
		"r":
			node = Rock.new()
		"g":
			node = Egg.new()
		"m":
			node = Monster.new()
		"p":
			node = Spirit.new()
		_:
			node = Node3D.new()

	# Try FBX model first (full node subtree with sub-meshes)
	if type_char in _fbx_templates:
		var fbx_node: Node3D = _fbx_templates[type_char].duplicate()
		fbx_node.name = "Mesh"
		fbx_node.scale *= 0.3 #Vector3(1.0 / 2.0, 1.0 / 2.0, 1.0 / 2.0)
		if is_3d:
			fbx_node.position.y = 0.5
		else:
			fbx_node.position.y = 0.5
		node.add_child(fbx_node)
		return node

	# Spirit — plasma orb shader (special case)
	if type_char == "p":
		return _create_spirit_orb(node, is_3d)

	# Fallback to primitive meshes for types without FBX models
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Mesh"

	var material := StandardMaterial3D.new()
	material.albedo_color = COLORS.get(type_char, Color(1.0, 0.0, 1.0))  # Magenta fallback
	material.roughness = 0.7

	# Per-type material tweaks
	match type_char:
		"d":  # Diamond — shiny
			material.roughness = 0.15
			material.metallic = 0.6
		"k", "C":  # Keys — metallic
			material.roughness = 0.3
			material.metallic = 0.8
		"b":  # Bomb — slight sheen
			material.roughness = 0.4
			material.metallic = 0.3
		"u":  # Skull — bone-like
			material.roughness = 0.9
		"n", "y":  # Transporter — slight glow
			material.roughness = 0.3
			material.emission_enabled = true
			material.emission = COLORS.get("n", Color(0.8, 0.0, 0.8))
			material.emission_energy_multiplier = 0.4
		"5", "1", "2", "3", "4", "6", "7", "8", "9", "%", "&", "(", "!":  # Walls
			material.roughness = 0.85
		"e":  # Earth — matte
			material.roughness = 0.95

	var mesh: Mesh
	var mesh_y_offset: float = 0.5

	match type_char:
		"u":  # Skull - sphere
			var sphere := SphereMesh.new()
			sphere.radius = 0.35
			sphere.height = 0.7
			mesh = sphere
			mesh_y_offset = 0.35

		"n", "y":  # Transporter, LevelTransport - cylinder (flat disc)
			var cyl := CylinderMesh.new()
			cyl.top_radius = 0.4
			cyl.bottom_radius = 0.4
			cyl.height = 0.1
			mesh = cyl
			mesh_y_offset = 0.05

		"e":  # Earth - slightly smaller box
			var box := BoxMesh.new()
			box.size = Vector3(0.9, 0.9, 0.9)
			mesh = box
			mesh_y_offset = 0.45

		"s":  # Safe - slightly smaller box
			var box := BoxMesh.new()
			box.size = Vector3(0.9, 0.9, 0.9)
			mesh = box
			mesh_y_offset = 0.45

		"f":  # Fungus
			var box := BoxMesh.new()
			box.size = Vector3(0.8, 0.8, 0.8)
			mesh = box
			mesh_y_offset = 0.4

		_:  # Default: walls, barriers, filled walls - full box
			var box := BoxMesh.new()
			if type_char in WALL_CHARS:
				box.size = Vector3(1.0, 1.0, 1.0)
			else:
				box.size = Vector3(0.8, 0.8, 0.8)
			mesh = box

	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	mesh_instance.position.y = mesh_y_offset

	node.add_child(mesh_instance)
	return node


static var _plasma_shader: Shader = null

static func _create_spirit_orb(node: Node3D, is_3d: bool) -> Node3D:
	# Create a plasma orb spirit with custom shader
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Mesh"

	# High-subdivision sphere for smooth vertex displacement
	var sphere := SphereMesh.new()
	sphere.radius = 0.35
	sphere.height = 0.7
	sphere.radial_segments = 32
	sphere.rings = 24
	mesh_instance.mesh = sphere
	mesh_instance.position.y = 0.35

	# Load shader (cached)
	if _plasma_shader == null:
		_plasma_shader = load("res://shaders/plasma_orb.gdshader")

	var mat := ShaderMaterial.new()
	mat.shader = _plasma_shader

	# Set default uniform values
	mat.set_shader_parameter("orb_color", Color(0.3, 0.5, 1.0, 1.0))
	mat.set_shader_parameter("orb_alpha", 0.85)
	mat.set_shader_parameter("glow_intensity", 1.2)
	mat.set_shader_parameter("scroll_speed_1", 0.3)
	mat.set_shader_parameter("scroll_speed_2", 0.2)
	mat.set_shader_parameter("electric_scale", 3.0)
	mat.set_shader_parameter("electric_brightness", 1.0)
	mat.set_shader_parameter("displacement_strength", 0.06)
	mat.set_shader_parameter("displacement_speed", 1.2)
	mat.set_shader_parameter("displacement_scale", 2.5)
	mat.set_shader_parameter("distortion_strength", 0.04)
	mat.set_shader_parameter("distortion_speed", 0.5)
	mat.set_shader_parameter("distortion_scale", 3.0)
	mat.set_shader_parameter("fresnel_power", 2.5)
	mat.set_shader_parameter("fresnel_intensity", 0.8)
	mat.set_shader_parameter("fresnel_color", Color(0.6, 0.8, 1.0, 1.0))

	mesh_instance.material_override = mat

	# Add a subtle point light inside the orb for scene illumination
	var light := OmniLight3D.new()
	light.light_color = Color(0.4, 0.6, 1.0)
	light.light_energy = 0.4
	light.omni_range = 3.0
	light.omni_attenuation = 2.0
	light.position.y = 0.35
	light.name = "OrbGlow"

	node.add_child(mesh_instance)
	node.add_child(light)
	return node
