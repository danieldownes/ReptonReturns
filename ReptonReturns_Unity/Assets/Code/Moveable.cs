using UnityEngine;

public class Moveable : Piece
{
    public Vector3 LastPosition;
    public Vector3 vLastPositionAbs;    // Last absolute position (repton shuffle + smoother tweens)

    public Vector3 Direction;
    public Vector3 LastDirection;

    public float LastTime;
    public float TimeToMove;

    public void Init()
    {
        base.Init();
        LastTime = 0f;
        TimeToMove = 0.3f;
    }

    public void Update()
    {
        if (LastTime > 0.00f)
            move();
    }

    public bool MoveableTo(Vector3 vPos, Vector3 vDir)
    {
        bool moveableTo = true;
        bool bUpdateMap = true;

        RaycastHit hit;
        Physics.Raycast(vPos, vDir, out hit, 1f);

        if (hit.collider == null)
            return true;

        Debug.DrawRay(vPos, vDir * hit.distance, Color.red, 3f);
        Debug.Log("Did Hit");

        Moveable rock = hit.collider.gameObject.GetComponent<Moveable>();

        if (rock == null)
            return true;

        //if( rock.MoveableTo(rock.Position + vDir, vDir))

        rock.Move(vDir);

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
                */

        return true;
    }


    public bool Move(Vector3 direction)
    {
        Vector3 vNewPos;

        vNewPos = Position + direction;

        LastTime = TimeToMove;

        LastPosition = Position;
        vLastPositionAbs = transform.position;
        Position += direction;

        return true;
    }

    private void move()
    {
        transform.position = Vector3.Lerp(vLastPositionAbs, Position, (TimeToMove - LastTime) / TimeToMove);
        LastTime -= UnityEngine.Time.deltaTime;
    }

}
