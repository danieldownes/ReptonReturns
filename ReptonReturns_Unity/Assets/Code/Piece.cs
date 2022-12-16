using UnityEngine;

public class Piece : MonoBehaviour
{
    public Level.Piece PieceType;
    public Vector3 Position;

    public void Init()
    {
        Position = transform.position;
    }
}