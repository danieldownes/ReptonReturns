# egg.gd
# Repton Returns - Godot 4.6 Port
# Egg piece — falls under gravity like a rock, cracks into a monster on impact
# Original: Egg behavior from Fallable.cs / Monster.cs (EggCracking state)

class_name Egg
extends Fallable


func _ready() -> void:
	init()
	stopped_falling.connect(_on_stopped_falling)


func _process(delta: float) -> void:
	super._process(delta)
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
	# Egg cracks after free fall (fell more than 1 cell)
	if free_fall:
		# Defer the crack so check_if_fall() finishes first
		call_deferred("_check_crack")


func _check_crack() -> void:
	# Only crack if truly stopped (not continuing to fall)
	if not falling:
		_crack()


func _crack() -> void:
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
