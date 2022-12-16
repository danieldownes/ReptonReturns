using UnityEngine;

public abstract class Movable : Piece
{
    [HideInInspector] public Vector3 LastPosition;
    [HideInInspector] public Vector3 vLastPositionAbs;    // Last absolute position (repton shuffle + smoother tweens)

    [HideInInspector] public Vector3 Direction;
    [HideInInspector] public Vector3 LastDirection;

    [HideInInspector] public float LastTime;
    [HideInInspector] protected float timeToMove;

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

    public T MovableTo<T>(Vector3 vPos, Vector3 vDir)
    {
        RaycastHit hit;
        Physics.Raycast(vPos, vDir, out hit, 1f);

        if (hit.collider == null)
            return default;

        Debug.DrawRay(vPos, vDir * hit.distance, Color.red, 3f);

        return (T)hit.collider.gameObject.GetComponent<T>();


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

            case Level.Piece.Bomb:

                // Only if objectives are completed
                //if( If rrRepton.intDimondsCollected <> rrMap.intTotDimonds _
                //Or rrMap.intTotCrowns <> 0 Or rrMap.intTotEggs <> 0 Or rrMap.intTotMonstersAlive <> 0 Then
                bMoveableTo = false;
                break;

            case Level.Piece.Monster:
            case Level.Piece.Skull:
            case Level.Piece.Fungus:
                DontReplace = 2;
                break;
        }
                */


    }


    public virtual bool Move(Vector3 direction)
    {
        LastTime = timeToMove;

        LastDirection = Direction;
        Direction = direction;

        LastPosition = Position;
        vLastPositionAbs = transform.position;
        Position += direction;

        return true;
    }

    private void move()
    {
        transform.position = Vector3.Lerp(vLastPositionAbs, Position, (timeToMove - LastTime) / timeToMove);
        LastTime -= UnityEngine.Time.deltaTime;
    }

}
