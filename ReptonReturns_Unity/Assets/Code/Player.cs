using System.Collections.Generic;
using UnityEngine;

public class Player : Movable
{
    public PlayerView view;

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
    //private State LastAction;

    public bool CanMove = true;

    public int Lives;

    private int WantMoveMe;

    // If set, wont replace old map piece with a space (eg monster, fungus, etc..)
    //private int DontReplace = 0;

    public List<string> Inventory = new List<string>();
    public string[] playerVars;

    private void Start()
    {
        Lives = 3;
        PlayerState = State.Stoped;
        LastTime = 0.0f;

        Position = transform.position;

        view.OnMoveComplete += OnMoveComplete;
    }

    private void OnMoveComplete()
    {
        OldState = PlayerState;
        LastDirection = Direction;

        // Change state
        if (PlayerState == State.Walk)
            PlayerState = State.Stoped;

    }

    private new void Update()
    {
        if (Input.GetAxis("Horizontal") < 0)
            Move(Vector3.left);

        else if (Input.GetAxis("Horizontal") > 0)
            Move(Vector3.right);

        else if (Input.GetAxis("Vertical") > 0)
            Move(Vector3.forward);

        else if (Input.GetAxis("Vertical") < 0)
            Move(Vector3.back);

        if (PlayerState != State.Stoped)
            view.Move3D(Position, LastPosition);

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

    public new void Move(Vector3 direction)
    {
        if (PlayerState != State.Stoped && PlayerState != State.PushNoWalk)
            return;

        // Walkable floor over intended direction?
        Piece piece = MovableTo<Piece>(Position + direction, Vector3.down * 2, Color.green);
        if (piece == null)
            return;

        // No obstruction in intended direction
        piece = MovableTo<Piece>(Position, direction);
        if (piece != null)
        {
            if (piece.Traversable == false)
                return;
            else
                piece.Traverse();
        }

        // Push a movable?
        Movable movable = MovableTo<Movable>(Position, direction);
        if (movable != null)
        {
            // Can not push a movable if it is obstructed
            Piece movableNext = movable.MovableTo<Piece>(movable.Position, direction);
            if (movableNext != null)
                return;
        }
        else
        {

        }

        // Removing a piece that is supporting a fallable, Repton should hold it
        Fallable fallable = MovableTo<Fallable>(Position + direction, Vector3.up, Color.green);
        if (fallable != null)
        {

            // Repton shuffle?
            if (LastDirection != direction && OldState != State.Stoped)
            {
                // Slide this piece
                fallable.Move(direction);
                print("REPTON shuffle");
            }
            else
            {
                // Just hold above piece
                fallable.Move(Vector3.zero);
                print("LastDirection = " + LastDirection);
            }

        }

        // Push Movable
        if (movable != null)
            movable.Move(direction);

        // Move Player
        base.Move(direction);

        view.StartMove(LastDirection, direction);

        PlayerState = State.Walk;
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
