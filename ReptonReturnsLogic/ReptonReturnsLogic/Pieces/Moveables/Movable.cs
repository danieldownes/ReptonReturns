using ReptonReturnsLogic.World;

namespace ReptonReturnsLogic.Pieces;
public abstract class Movable : Piece
{
    public event Action OnMoveStarted;
    public event Action OnMoveMidway;
    public event Action OnMoveCompleted;

    public IVector LastPosition;
    public IVector vLastPositionAbs;    // Last absolute position (repton shuffle + smoother tweens)

    public IVector Direction;
    public IVector LastDirection;

    public float LastTime;
    protected float timeToMove;

    public new void Init()
    {
        base.Init();
        LastTime = 0f;
        timeToMove = 0.3f;
    }

    public void Update()
    {
        if (LastTime > 0.00f)
            move();
    }

    public T MovableTo<T>(IVector pos, IVector dir)
    {
        /*
        // Static pieces...
        switch (Level.Piece.Space) //(Level.Piece)cPiece.TypeID)
        {
            case Level.Piece.Door:
                // Has the key to this door?
                //if (lInventory.Contains("Coloured Key:" + game.loadedLevel.colourKey[cPiece.iRef].ToString()))
                //{
                //lInventory.Add("DOOR:" + cPiece.iRef.ToString());
                //}
                //else
                bMoveableTo = false;

                break;
        }
        */


    }


    public virtual bool Move(IVector direction)
    {
        LastTime = timeToMove;

        LastDirection = Direction;
        Direction = direction;

        LastPosition = Position;
        //vLastPositionAbs = transform.position;
        Position.Add(direction);

        return true;
    }

    private void move()
    {
        transform.position = IVector.Lerp(vLastPositionAbs, Position, (timeToMove - LastTime) / timeToMove);
        LastTime -= UnityEngine.Time.deltaTime;
    }

}
