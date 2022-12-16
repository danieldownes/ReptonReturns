using UnityEngine;

public class Piece : MonoBehaviour
{
    public Level.Piece PieceType;
    public bool Traversable;

    [HideInInspector] public Vector3 Position;

    public void Init()
    {
        Position = transform.position;
    }
}