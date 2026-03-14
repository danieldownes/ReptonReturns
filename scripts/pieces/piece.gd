# piece.gd
# Repton Returns - Godot 4.6 Port
# Base class for all level pieces
# Original: Piece.cs

class_name Piece
extends Node3D


var piece_type: String = "0"    # Level.Piece PieceType;
var traversable: bool = false   # public bool Traversable;

var grid_position: Vector3 = Vector3.ZERO   # [HideInInspector] public Vector3 Position;


func init() -> void:
	# public virtual void Init()
	# In Unity, Position == transform.position (grid coords).
	# In our version, grid_position is set explicitly by level.gd before _ready().
	# Don't overwrite it with the slanted world position.
	pass


func is_at_grid(pos: Vector3) -> bool:
	return int(grid_position.x) == int(pos.x) \
		and int(grid_position.y) == int(pos.y) \
		and int(grid_position.z) == int(pos.z)


func traverse() -> void:
	# public virtual void Traverse()
	queue_free()  # Destroy(this.gameObject);
