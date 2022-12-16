using UnityEngine;

public class Spirit : Moveable
{
    public int State;               // 0 = Seek (check direction), 1 = Moving

    private bool firstMove;         // Helps to make sure the first move of the spirit is the same as origonal version of Repton

    private int cornTry;            // If spirit did not move (ie, determined new direct) this is > 0, stops
                                    //  spirit from 'waiting' while turning around corners.
                                    //  Will try to 'move' spirit upto 4 times per function call to
                                    //  keep in sync. with other spirts 

    public char OnPiece;
    public char LastOnPiece;
    public int OnId;
    public int LastOnId;

    public void Init(Vector3 vPos)
    {
        PieceType = Level.Piece.Spirit;
        TimeToMove = 0.45f;
        OnPiece = '0';
        OnId = -1;
        State = 1;
        LastTime = 1.0f;
        Position = LastPosition = vPos;
        firstMove = true;
        LastDirection = Direction;
    }
    /*
    void Update()
    {
        LastTime -= UnityEngine.Time.deltaTime;

        if (State == 1 && LastTime <= 0.0f)
            State = 0;
        else
            ControlSeek();

        //Move3D();
        // Interpolate
        transform.position = Vector3.Lerp(LastPosition, Position, (TimeToMove - LastTime) / TimeToMove);
    }

    void Move(Vector3 vDir)
    {
        // Update local info

        State = 1;

        LastPosition = Position;
        LastDirection = Direction;

        Position += vDir;
        Direction = vDir;

        LastOnPiece = OnPiece;
        LastOnId = OnId;

        LastTime = TimeToMove;

        OnId = game.loadedLevel.GetMapPId(Position);

        // Does Repton die in result of this move?
        if (game.loadedLevel.GetMapP(Position) == 'i'
         || game.loadedLevel.GetMapP(LastPosition) == 'i')
        {
            game.playerObject.Die();
            //cOnPiece = '0';
        }

        game.loadedLevel.SetMapP(LastPosition, OnPiece, OnId);
        game.loadedLevel.SetMapP(Position, (char)pPieceType, iId);
    }

    public bool MoveableTo(Vector3 vPos, Vector3 vDir)
    {
        bool bMoveableTo;
        char cT;

        cT = game.loadedLevel.GetMapP(vPos + vDir);

        // Checks if a spirit can move to the piece at the given map coords.
        bMoveableTo = (cT == '0' || cT == 'i' || cT == 'e' || cT == 'c');

        return bMoveableTo;
    }

    public void ControlSeek()
    {
        char cT;
        bool bCanMove;
        Vector3 vOldDir;

        bCanMove = false;

        cornTry = 0;

        while (cornTry < 4 && !bCanMove)
        {
            vOldDir = Direction;

            if (firstMove) // Only do this if the first move
            {
                // Determine starting direction ...      ' (in origonal Repton this is done on every spirt move; hence 'dazed sprits')

                // If nothing is set, then default to Up
                Direction = LastDirection = Vector3.forward;

                // Move Right?
                if (!MoveableTo(Position, Vector3.forward))
                    Direction = Vector3.right;

                // Move Down?
                if (!MoveableTo(Position, Vector3.right))
                    Direction = Vector3.back;

                // Move Left?
                if (!MoveableTo(Position, Vector3.back))
                    Direction = Vector3.left;

                firstMove = false;
            }
            else
            {
                // Is there a wall (to the right) that we should hug? ...
                //vDirection = vOldDir;      // In case we turned right (if wall was infront) //??
                bCanMove = MoveableTo(Position, TurnCCW(Direction));

                // Do the check
                if (bCanMove)
                {
                    // So there was No wall there! Turn left Now
                    // AKA: Hug wall left (turn CCW)
                    Direction = TurnCCW(Direction);
                }

            }

            // Which way are we facing?
            bCanMove = MoveableTo(Position, Direction);

            // Ok to move forward??
            if (bCanMove)
            {
                Move(Direction);
                //cT = game.loadedLevel.GetMapP(Position);

                // If we went into a cage, we should turn into a dimond (deactivate and change map)
                //if (cT == 'c')
                //{
                //                ExSnds(9).PlaySound False
                //                
                //                bActive = False
                //                
                //                rrMap.SetData intCurX, intCurY, Dimond
                //                rrPieces(intCurX, intCurY).TypeID = DataInt2Str(Dimond)
                //}
                //            
                //            ' If we went into Repton, he should die
                //            If sTemp = "i" Or rrMap.GetData(intOldX, intOldY) = "i" Then
                //                rrRepton.Die
                //            End If
                //            
            }
            else
            {
                // Try next direction (turn clockwise)
                Direction = TurnCW(Direction);

                cornTry++;
            }
        }
    }

    private Vector3 TurnCW(Vector3 vDir)
    {
        if (vDir == Vector3.forward)
            vDir = Vector3.right;
        else if (vDir == Vector3.back)
            vDir = Vector3.left;
        else if (vDir == Vector3.left)
            vDir = Vector3.forward;
        else if (vDir == Vector3.right)
            vDir = Vector3.back;

        return vDir;
    }

    private Vector3 TurnCCW(Vector3 vDir)
    {
        if (vDir == Vector3.forward)
            vDir = Vector3.left;
        else if (vDir == Vector3.back)
            vDir = Vector3.right;
        else if (vDir == Vector3.left)
            vDir = Vector3.back;
        else if (vDir == Vector3.right)
            vDir = Vector3.forward;

        return vDir;
    }
    */
}