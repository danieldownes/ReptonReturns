using UnityEngine;
using System.Collections.Generic;

public class Player : Moveable2
{
    public enum State
    {
        Stoped = 0,
        Walk = 1,
        Push = 2,
        PushNoWalk = 3,
        DigAndWalk = 4,
        Board = 5
    };

    public Vector3 vStartPos;
    public State iPlayerState;
    public bool bCanMove = true;
    private bool updatedMove = true;
    private int iDontReplace = 0;  // If set, wont replace old map piece with a space (eg monster, fungus, etc..)
    public int iLives;

    public List<string> lInventory = new List<string>();
    public string[] playerVars;

    void Start()
    {
        iLives = 3;
        iPlayerState = 0; //enmPlayerState.Stopped;
        fTime = 0.0f;
        fTimeToMove = 0.3f;
        vLastDirection = Vector3.back;
        vDirection = Vector3.forward;
    }

    void Update()
    {
        if (fTime > 0.01f)
        {
            fTime -= Time.deltaTime;

            // Update movmement of Player on map
            if (!updatedMove && fTime <= fTimeToMove * 0.3)
            {
                CheckPickup();
                if (iDontReplace != 2)
                    game.loadedLevel.SetMapP(vPosition, (char)Level.Piece.Repton);
                if (iDontReplace != 1)
                    game.loadedLevel.SetMapP(vLastPosition, (char)Level.Piece.Space);
                else
                    iDontReplace = 0;
                iDontReplace--;

                updatedMove = true;
            }
        }
        else
        {
            fTime = 0.0f;

            iPlayerState = State.Stoped;

            // Check for new movement, if allowed
            if (bCanMove)
            {
                if (Input.GetAxis("Horizontal") < 0)
                    Move(Vector3.left);

                else if (Input.GetAxis("Horizontal") > 0)
                    Move(Vector3.right);

                else if (Input.GetAxis("Vertical") > 0)
                    Move(Vector3.forward);

                else if (Input.GetAxis("Vertical") < 0)
                    Move(Vector3.back);
            }
        }

        Move3D();
    }

    public void MoveToPos(Vector3 vNewPos)
    {
        if (iDontReplace != 1)
            game.loadedLevel.SetMapP(vLastPosition, (char)Level.Piece.Space);
        game.loadedLevel.SetMapP(vNewPos, (char)Level.Piece.Repton);

        vLastPosition = vPosition = vNewPos;

        //rr2gameObject.guiObject.OnGUI ();
    }

    public void Move(Vector3 vDirectionToMove)
    {
        if (iPlayerState == State.Stoped || iPlayerState == State.PushNoWalk)
        {
            if (MoveableTo(vPosition + vDirectionToMove, vDirectionToMove))
            {
                fTime = fTimeToMove;
                vLastPosition = vPosition;
                //iPlayerState = enmPlayerState.Walk;

                //Debug.Log("Move" + vPosition.x.ToString() + "," + vPosition.z.ToString());

                vLastDirection = vDirection;
                vDirection = vDirectionToMove;

                // Add the movement
                vPosition += vDirectionToMove;

                updatedMove = false;

                //rr2gameObject.guiObject.sInventory = vDirectionToMove.x.ToString();
                //Debug.Log("sInventory=" + vDirectionToMove.x.ToString());


                iPlayerState = State.Walk;
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
        transform.position = Vector3.Lerp(AddSlant(vLastPosition), AddSlant(vPosition), (fTimeToMove - fTime) / fTimeToMove);

        if (vLastDirection != vDirection)
        {

            vRotFrom = Quaternion.LookRotation(vLastDirection);
            vRotTo = Quaternion.LookRotation(vDirection);

            // Spectial case to ensure repton moves in the right direction
            if (vLastDirection == Vector3.left)
                vRotFrom = Quaternion.LookRotation(vLeft);

            if (vLastDirection == Vector3.right)
                vRotFrom = Quaternion.LookRotation(vRight);

            // Apply the rotation
            GameObject reptonObject = GameObject.Find("ReptonMesh");
            reptonObject.transform.rotation = Quaternion.identity;
            reptonObject.transform.rotation = Quaternion.Lerp(vRotFrom, vRotTo, (fTimeToMove - fTime) / fTimeToMove);

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

        Level.MapPiece2d cPiece = game.loadedLevel.MapDetail[(int)vPosition.x, (int)-vPosition.z];

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
                game.loadedLevel.MapDetail[(int)vLastPosition.x, (int)-vLastPosition.z].TypeID = (char)Level.Piece.Space;
                vLastPosition = vPosition;
                vPosition = vStartPos = game.loadedLevel.tTransporter[cPiece.iRef];
                vDirection = Vector3.back;

                cPiece.iRef = 0;

                // Set to update position of player
                fTime = 0.2f;

                // Start pause
                //rrGame.Pause 2.5

                // Start FX

                break;
        }

        if (bUpdateMap)
        {
            // Remove the graphic
            game.loadedLevel.RemovePiece(vPosition);
        }

        return;
    }


    public int Die()
    {
        iLives--;

        // Reset to starting position]
        game.loadedLevel.SetMapP(vPosition, '0');
        MoveToPos(vStartPos);
        vDirection = Vector3.back;

        // Reset bomb?

        return iLives;
    }

}
