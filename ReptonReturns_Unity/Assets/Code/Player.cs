using UnityEngine;
using System.Collections.Generic;

public class Player : Moveable
{
    public GameObject ReptonMesh;

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

    public bool CanMove = true;
    private bool updatedMove = true;

    public int Lives;

    private bool InterMove;
    private int WantMoveMe;

    // If set, wont replace old map piece with a space (eg monster, fungus, etc..)
    private int DontReplace = 0;

    public List<string> Inventory = new List<string>();
    public string[] playerVars;

    private void Start()
    {
        Lives = 3;
        PlayerState = State.Stoped;
        LastTime = 0.0f;
        TimeToMove = 0.3f;
        LastDirection = Vector3.forward;
        Direction = Vector3.back;
        Position = transform.position;
    }
        
    private new void Update()
    {
        LastTime -= UnityEngine.Time.deltaTime;

        // Inter-mediate move (half way)
        if (LastTime < (TimeToMove * 0.4f) && InterMove)
        {
            // Almost finished move (interval-move)? 
            InterMove = false;

            // Probably not continuously moving?
            if (WantMoveMe < 2)
            {
                //playStepSound();
            }

            // Update movement of Player on map
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
            //camObject.GetComponent<AudioSource>().Stop();
        }

        if (WantMoveMe > 0)
            WantMoveMe--;
    }


    public void MoveToPos(Vector3 vNewPos)
    {
        LastPosition = Position = vNewPos;
    }

    public new void Move(Vector3 DirectionToMove)
    {
        if (PlayerState != State.Stoped && PlayerState != State.PushNoWalk)
            return;

        if (MoveableTo(Position, DirectionToMove))
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

    public void Move3D()
    {
        // This is needed to force player to turn towards camera when going left>right & right>left
        Vector3 vLeft = new Vector3(-0.99f, 0f, -0.01f);
        Vector3 vRight = new Vector3(0.99f, 0f, -0.01f);

        Quaternion vRotTo = Quaternion.LookRotation(Vector3.forward);
        Quaternion vRotFrom = Quaternion.LookRotation(Vector3.back);

        // Interpolate //
        transform.position = Vector3.Lerp(LastPosition, Position, (TimeToMove - LastTime) / TimeToMove);

        if (LastDirection != Direction)
        {
            vRotFrom = Quaternion.LookRotation(LastDirection);
            vRotTo = Quaternion.LookRotation(Direction);

            // Special case to ensure Repton moves in the right direction
            if (LastDirection == Vector3.left)
                vRotFrom = Quaternion.LookRotation(vLeft);

            if (LastDirection == Vector3.right)
                vRotFrom = Quaternion.LookRotation(vRight);

            // Apply the rotation
            ReptonMesh.transform.rotation = Quaternion.identity;
            ReptonMesh.transform.rotation = Quaternion.Lerp(vRotFrom, vRotTo, (TimeToMove - LastTime) / TimeToMove);

        }
    }


    /*

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
                //game.loadedLevel.OpenSafes();
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
                DontReplace = 2;
                break;

            case Level.Piece.Skull:
            case Level.Piece.Fungus:
                bUpdateMap = false;
                Die();

                break;

            case Level.Piece.Transporter:
                //game.loadedLevel.MapDetail[(int)LastPosition.x, (int)-LastPosition.z].TypeID = (char)Level.Piece.Space;
                LastPosition = Position;
                //Position = StartPos = game.loadedLevel.tTransporter[cPiece.iRef];
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
            //game.loadedLevel.RemovePiece(Position);
        }

        return;
    }
    */


    public int Die()
    {
        Lives--;

        // Reset to starting position]
        //game.loadedLevel.SetMapP(Position, '0');
        MoveToPos(StartPos);
        Direction = Vector3.back;

        // Reset bomb?

        return Lives;
    }

}
