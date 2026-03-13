# egg.gd
# Repton Returns - Godot 4.6 Port
# Egg piece — falls under gravity like a rock, cracks into a monster on impact
# Original: Egg behavior from Fallable.cs / Monster.cs (EggCracking state)

class_name Egg
extends Fallable


const CRACK_TIME: float = 0.8  # seconds of visible cracking before monster spawns

var _cracking: bool = false
var _crack_timer: float = 0.0


func _ready() -> void:
	init()
	stopped_falling.connect(_on_stopped_falling)


func _process(delta: float) -> void:
	super._process(delta)

	if _cracking:
		_crack_timer -= delta
		if _crack_timer <= 0.0:
			_cracking = false
			_hatch()
		return

	check_fall()


func move(dir: Vector3) -> bool:
	# Called when pushed by the player (horizontal moves)
	# Falling moves go through Fallable._do_fall() which bypasses this

	if level == null:
		return false

	# Check if destination is empty
	var target_pos: Vector3 = grid_position + dir
	var target_piece: String = level.get_map_at(target_pos)

	if target_piece != "0":
		return false  # Blocked

	# Update map data for the push
	_update_map_for_move(dir)

	# Start the move
	if super.move(dir) == false:
		return false

	return true


func traverse() -> void:
	# Eggs are not traversable
	pass


func _on_stopped_falling() -> void:
	# Egg cracks after any fall (1 cell or more)
	call_deferred("_check_crack")


func _check_crack() -> void:
	# Only crack if truly stopped (not continuing to fall)
	if not falling and not _cracking:
		_start_cracking()


func _start_cracking() -> void:
	if level == null:
		return

	_cracking = true
	_crack_timer = CRACK_TIME

	# Play egg cracking sound
	var snd := AudioStreamPlayer3D.new()
	snd.stream = SFX.egg_cracking
	snd.max_distance = 40.0
	snd.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
	snd.position = position
	level.add_child(snd)
	snd.finished.connect(snd.queue_free)
	snd.play()

	# Visual feedback: shrink/shake the egg during cracking
	var mesh_node = get_node_or_null("Mesh")
	if mesh_node:
		var tween := create_tween()
		tween.set_loops(4)
		tween.tween_property(mesh_node, "rotation_degrees:z", 10.0, CRACK_TIME / 8.0)
		tween.tween_property(mesh_node, "rotation_degrees:z", -10.0, CRACK_TIME / 8.0)


func _hatch() -> void:
	if level == null:
		return

	var my_id: int = level.get_map_id_at(grid_position)

	# Create monster at this position
	var monster_node: Node3D = PieceFactory.create_piece("m")
	if monster_node == null:
		return

	monster_node.position = _grid_to_world(grid_position)
	monster_node.name = "m_" + str(int(grid_position.x)) + "_" + str(int(grid_position.z))

	if monster_node is Monster:
		monster_node.level = level
		monster_node.piece_type = "m"
		monster_node.monster_init(grid_position)

	# Replace in objects array
	if my_id >= 0 and my_id < level.objects.size():
		level.objects[my_id] = monster_node

	# Update map with monster type and id
	level.set_map_at(grid_position, "m")
	level.set_map_id_at(grid_position, my_id)

	# Set monster's object_id so it writes correct id on future moves
	if monster_node is Monster:
		monster_node.object_id = my_id

	level.pieces_container.add_child(monster_node)
	level.monsters_alive += 1
	level.eggs -= 1

	# Remove egg
	queue_free()
