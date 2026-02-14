# diamond.gd
# Repton Returns - Godot 4.6 Port
# Collectible diamond with audio feedback
# Original: Diamond.cs

class_name Diamond
extends Piece


#@export var collected_sound: AudioStreamPlayer3D    # [SerializeField] private AudioSource collectedSound;


func traverse() -> void:
	# public override void Traverse()
	# collectedSound.Play();
	# Destroy(this.gameObject, 0.5f);
	# TODO: Play collected sound
	queue_free()
