using UnityEngine;
using System.Collections.Generic;

public class Player : Moveable2
{
    private GameObject playerObject;
    private GameObject camObject;

    public enum State
    {
        Stoped = 0,
        Walk = 1,
        Push = 2,
        PushNoWalk = 3,
        DigAndWalk = 4,
        Board = 5
    };

    public Vector3 StartPos;
    public State PlayerState;
    private State OldState;
    private State LastAction;

    public bool bCanMove = true;
    private bool updatedMove = true;
    // If set, wont replace old map piece with a space (eg monster, fungus, etc..)
    private int iDontReplace = 0;
    public int iLives;

    bool bStepSoundTog;
    bool InterMove;
    int iWantMoveMe;


    public List<string> lInventory = new List<string>();
    public string[] playerVars;

    void Start()
    {
        iLives = 3;
        PlayerState = State.Stoped;
        LastTime = 0.0f;
        TimeToMove = 0.3f;
        LastDirection = Vector3.back;
        Direction = Vector3.forward;
    }


    void Update()
    {
        LastTime -= UnityEngine.Time.deltaTime;

        // Inter-mediate move (half way)
        if (LastTime < (TimeToMove * 0.4f) && InterMove)
        {
            // Almost finished move (interval-move)? 
            InterMove = false;

            // Probably not continusouly moving?
            if (iWantMoveMe < 2)
            {
                //playStepSound();
            }

            // Update movmement of Player on map
            //updatedMove = true;
        }

        // Still going, or ready for next move?
        if (LastTime < 0.001f)
        {
            LastTime = 0.0f;

            if (PlayerState != State.Stoped)
            {

            }

            // Just stopped pushing?
            if (PlayerState == State.Push)
            {

            }
            OldState = PlayerState;
            PlayerState = State.Stoped;

            // Just finished doing? Then stop undo sound
            /*
            if (wasUndoing)
            {
                camObject.GetComponent<AudioSource>().Stop();
                camObject.GetComponent<AudioSource>().clip = SndPush;
                camObject.GetComponent<AudioSource>().loop = false;
                wasUndoing = false;
            }
            */
        }


        if (Input.GetAxis("Horizontal") < 0)
            Move(Vector3.left);

        else if (Input.GetAxis("Horizontal") > 0)
            Move(Vector3.right);

        else if (Input.GetAxis("Vertical") > 0)
            Move(Vector3.forward);

        else if (Input.GetAxis("Vertical") < 0)
            Move(Vector3.back);

        Move3D();

        // Was pushing (continuously), and now stopped?
        if (OldState == State.Push && PlayerState != State.Push)
        {
            // Stop pushing sound
            camObject.GetComponent<AudioSource>().Stop();
        }

        if (iWantMoveMe > 0)
            iWantMoveMe--;
    }


    public void MoveToPos(Vector3 vNewPos)
    {
        if (iDontReplace != 1)
            game.loadedLevel.SetMapP(LastPosition, (char)Level.Piece.Space);
        game.loadedLevel.SetMapP(vNewPos, (char)Level.Piece.Repton);

        LastPosition = Position = vNewPos;

        //rr2gameObject.guiObject.OnGUI ();
    }

    public void Move(Vector3 DirectionToMove)
    {
        if (PlayerState == State.Stoped || PlayerState == State.PushNoWalk)
        {
            if (MoveableTo(Position + DirectionToMove, DirectionToMove))
            {
                LastTime = TimeToMove;
                LastPosition = Position;
                //iPlayerState = enmPlayerState.Walk;

                LastDirection = Direction;
                Direction = DirectionToMove;

                // Add the movement
                Position += DirectionToMove;

                updatedMove = false;

                //rr2gameObject.guiObject.sInventory = vDirectionToMove.x.ToString();
                //Debug.Log("sInventory=" + vDirectionToMove.x.ToString());


                PlayerState = State.Walk;
            }
            else
            {
                //iPlayerState = enmPlayerState.PushNoWalk;
            }
        }
    }

    public void Move3D()
    {
        // This is needed to force player to turn towards camera when going left>right & right>left
        Vector3 vLeft = new Vector3(-0.99f, 0f, -0.01f);
        Vector3 vRight = new Vector3(0.99f, 0f, -0.01f);

        Quaternion vRotTo = Quaternion.LookRotation(Vector3.forward);
        Quaternion vRotFrom = Quaternion.LookRotation(Vector3.back);

        // Interpolate //
        transform.position = Vector3.Lerp(AddSlant(LastPosition), AddSlant(Position), (TimeToMove - LastTime) / TimeToMove);

        if (LastDirection != Direction)
        {

            vRotFrom = Quaternion.LookRotation(LastDirection);
            vRotTo = Quaternion.LookRotation(Direction);

            // Spectial case to ensure repton moves in the right direction
            if (LastDirection == Vector3.left)
                vRotFrom = Quaternion.LookRotation(vLeft);

            if (LastDirection == Vector3.right)
                vRotFrom = Quaternion.LookRotation(vRight);

            // Apply the rotation
            GameObject reptonObject = GameObject.Find("ReptonMesh");
            reptonObject.transform.rotation = Quaternion.identity;
            reptonObject.transform.rotation = Quaternion.Lerp(vRotFrom, vRotTo, (TimeToMove - LastTime) / TimeToMove);

        }
    }

    public bool MoveableTo(Vector3 vPos, Vector3 vDir)
    {
        bool bMoveableTo = true;
        bool bUpdateMap = true;
        Level.MapPiece2d cPiece = game.loadedLevel.MapDetail[(int)vPos.x, (int)-vPos.z];

        // Static pieces...
        switch ((Level.Piece)cPiece.TypeID)
        {
            case Level.Piece.Door:
                // Has the key to this door?
                if (lInventory.Contains("Coloured Key:" + game.loadedLevel.colourKey[cPiece.iRef].ToString()))
                {
                    //lInventory.Add("DOOR:" + cPiece.iRef.ToString());
                }
                else
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
                iDontReplace = 2;
                break;


            case Level.Piece.Wall:
            case Level.Piece.Wall1:
            case Level.Piece.Wall2:
            case Level.Piece.Wall3:
            case Level.Piece.Wall4:
            case Level.Piece.Wall6:
            case Level.Piece.Wall7:
            case Level.Piece.Wall8:
            case Level.Piece.Wall9:
            case Level.Piece.FilledWall:
            case Level.Piece.FilledWall1:
            case Level.Piece.FilledWall3:
            case Level.Piece.FilledWall7:
            case Level.Piece.FilledWall9:
            case Level.Piece.Barrier:
            case Level.Piece.Cage:
            case Level.Piece.Safe:
                bMoveableTo = false;
                break;

        }


        // Movable pieces...
        if (cPiece.TypeID == (char)Level.Piece.Rock || cPiece.TypeID == (char)Level.Piece.Egg)
        {

            // If egg is cracking,
            //if( (char)cPiece.TypeID == (char)rr2level.enmPiece.Egg && )
            //If rrPieces(intX, intY).intRockOrEggID = -1 Then
            //bMoveableTo = false;

            bMoveableTo = false;

            if (vDir == Vector3.left || vDir == Vector3.right)
            {
                Level.MapPiece2d cPieceTo = game.loadedLevel.MapDetail[(int)(vPos.x + vDir.x), (int)-vPos.z];

                bMoveableTo = false;

                if (cPieceTo.TypeID == (char)Level.Piece.Space || cPieceTo.TypeID == (char)Level.Piece.Monster)
                {
                    Moveable oScript = game.loadedLevel.lObjects3[cPiece.id].GetComponent("rr2moveable") as Moveable;
                    if (oScript)
                    {
                        bMoveableTo = oScript.Move(vDir);
                    }
                }
            }
        }
        else if (bUpdateMap && bMoveableTo)
        {
            // Remove the graphic
            //try
            //{
            //	int pId = rr2gameObject.loadedLevel.RrMapDetail[(int)vPos.x, (int)-vPos.z].id;
            //		if( pId != -1)
            //      	Destroy(rr2gameObject.loadedLevel.lObjects3[pId]);
            //} catch {}
        }

        return bMoveableTo;
    }

    /*
    Private Function MoveableTo(intX As Integer, intY As Integer, intDirection As enmDirection) As Boolean

        If intTemp = enmPieceType.Rock Or (intTemp = enmPieceType.Egg) Then        ' Rocks or eggs
            If intDirection = Up Or intDirection = Down Then
                MoveableTo = False
            Else
                If intDirection = Left Then
                    If rrMap.GetData(intX - 1, intY) = DataInt2Str(enmPieceType.Space) Then
                        rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Left
                    ElseIf rrMap.GetData(intX - 1, intY) = DataInt2Str(enmPieceType.Monster) Then
                        rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Left
                    Else
                        MoveableTo = False
                    End If
                Else
                    If rrMap.GetData(intX + 1, intY) = DataInt2Str(enmPieceType.Space) Then
                        rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Right
                    ElseIf rrMap.GetData(intX + 1, intY) = DataInt2Str(enmPieceType.Monster) Then
                        rrRocksOrEggs(rrPieces(intX, intY).intRockOrEggID).Move Right
                    Else
                        MoveableTo = False
                    End If
                End If
            End If
        End If

    */
    public void CheckPickup()
    {
        bool bUpdateMap = true;

        Level.MapPiece2d cPiece = game.loadedLevel.MapDetail[(int)Position.x, (int)-Position.z];

        Debug.Log("moving to:" + (Level.Piece)cPiece.TypeID);

        // Static pieces...
        switch ((Level.Piece)cPiece.TypeID)
        {
            case Level.Piece.Dimond:
                this.GetComponent<AudioSource>().Play();
                break;

            case Level.Piece.Key:
                game.loadedLevel.OpenSafes();
                break;

            case Level.Piece.ColourKey:
                lInventory.Add("Coloured Key:" + cPiece.iRef.ToString());
                break;

            case Level.Piece.Bomb:

                // Already cheked if objectives are completed in MoveableTo

                break;

            case Level.Piece.Monster:
                //If rrMonster(rrPieces(intX, intY).intMonsterID).blnEarth Then MoveableTo = False
                bUpdateMap = false;
                iDontReplace = 2;
                break;

            case Level.Piece.Skull:
            case Level.Piece.Fungus:
                bUpdateMap = false;
                Die();

                break;

            case Level.Piece.Transporter:
                game.loadedLevel.MapDetail[(int)LastPosition.x, (int)-LastPosition.z].TypeID = (char)Level.Piece.Space;
                LastPosition = Position;
                Position = StartPos = game.loadedLevel.tTransporter[cPiece.iRef];
                Direction = Vector3.back;

                cPiece.iRef = 0;

                // Set to update position of player
                LastTime = 0.2f;

                // Start pause
                //rrGame.Pause 2.5

                // Start FX

                break;
        }

        if (bUpdateMap)
        {
            // Remove the graphic
            game.loadedLevel.RemovePiece(Position);
        }

        return;
    }


    public int Die()
    {
        iLives--;

        // Reset to starting position]
        game.loadedLevel.SetMapP(Position, '0');
        MoveToPos(StartPos);
        Direction = Vector3.back;

        // Reset bomb?

        return iLives;
    }

}
