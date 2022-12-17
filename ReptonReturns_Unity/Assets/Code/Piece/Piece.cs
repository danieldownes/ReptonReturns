using UnityEngine;

public class Piece : MonoBehaviour
{
    public Level.Piece PieceType;
    public bool Traversable;

    [HideInInspector] public Vector3 Position;

    public virtual void Init()
    {
        Position = transform.position;
    }

    public virtual void Traverse()
    {
        Destroy(this.gameObject);
    }
}