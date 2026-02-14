using ReptonReturnsLogic.World;

namespace ReptonReturnsLogic.Pieces;
public class Piece
{
    public event Action OnTraversed;

    public PieceTypes Type;
    public bool Traversable;

    public IVector Position;

    public virtual void Init()
    {
        //Position = transform.position;
    }

    public virtual void Traverse()
    {
        OnTraversed?.Invoke();
    }
}