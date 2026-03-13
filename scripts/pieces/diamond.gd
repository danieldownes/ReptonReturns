# diamond.gd
# Repton Returns - Godot 4.6 Port
# Collectible diamond with audio feedback
# Original: Diamond.cs

class_name Diamond
extends Piece


func traverse() -> void:
	# public override void Traverse()
	queue_free()
