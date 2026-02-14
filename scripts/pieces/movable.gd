# movable.gd
# Repton Returns - Godot 4.6 Port
# Abstract base for all movable objects with physics and interpolation
# Original: Movable.cs

class_name Movable
extends Piece


var last_position: Vector3 = Vector3.ZERO          # [HideInInspector] public Vector3 LastPosition;
var last_position_abs: Vector3 = Vector3.ZERO       # [HideInInspector] public Vector3 vLastPositionAbs;    // Last absolute position (repton shuffle + smoother tweens)

var direction: Vector3 = Vector3.ZERO               # [HideInInspector] public Vector3 Direction;
var last_direction: Vector3 = Vector3.ZERO           # [HideInInspector] public Vector3 LastDirection;

var last_time: float = 0.0                           # [HideInInspector] public float LastTime;
var time_to_move: float = 0.3                        # [HideInInspector] protected float timeToMove;

# Reference to level for map lookups (set by level.gd or game.gd at creation)
var level  # Untyped to avoid circular dependency with Level class

# Map slant constant (same as Level.MAP_SLANT)
const MAP_SLANT: float = 0.35


func init() -> void:
	# public new void Init()
	super.init()
	last_time = 0.0
	time_to_move = 0.3


func _process(delta: float) -> void:
	# public void Update()
	if last_time > 0.00:
		_do_move(delta)


#public T MovableTo<T>(Vector3 vPos, Vector3 vDir)
#{
#    RaycastHit hit;
#    Physics.Raycast(vPos, vDir, out hit, vDir.magnitude);
#    Debug.DrawRay(vPos, vDir * hit.distance, debug, 3f);
#    if (hit.collider == null)
#        return default;
#    return (T)hit.collider.gameObject.GetComponent<T>();
#}
# Collision detection is now done via map_detail lookups instead of raycasting


func move(dir: Vector3) -> bool:
	# public virtual bool Move(Vector3 direction)
	last_time = time_to_move

	last_direction = direction
	direction = dir

	last_position = grid_position
	last_position_abs = position  # Current world position (with slant)
	grid_position += dir

	return true


func _do_move(delta: float) -> void:
	# private void move()
	# transform.position = Vector3.Lerp(vLastPositionAbs, Position, (timeToMove - LastTime) / timeToMove);
	# Note: Monster.cs uses AddSlant() for interpolation targets.
	# We apply slant here so grid_position stays clean (x, 0, -grid_y).
	var target_world: Vector3 = _grid_to_world(grid_position)
	var t: float = (time_to_move - last_time) / time_to_move
	position = last_position_abs.lerp(target_world, t)
	last_time -= delta

	# Movement complete?
	if last_time <= 0.0:
		last_time = 0.0
		position = target_world
		_on_move_finished()


func _on_move_finished() -> void:
	# Override in subclasses for post-move logic
	pass


func is_moving() -> bool:
	return last_time > 0.0


func _grid_to_world(gp: Vector3) -> Vector3:
	# Convert grid_position (x, 0, grid_y) to world position
	# World: (x, -grid_y, grid_y * slant)
	# Since gp.z = grid_y: world = (gp.x, -gp.z, gp.z * MAP_SLANT)
	return Vector3(gp.x, -gp.z, gp.z * MAP_SLANT)
