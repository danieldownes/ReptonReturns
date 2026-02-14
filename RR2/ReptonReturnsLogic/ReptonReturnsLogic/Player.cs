using ReptonReturnsLogic.World;
using ReptonReturnsLogic.Pieces;

public class Player : Movable
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

    public Object StartPos;
    public State PlayerState;
    private State OldState;
    //private State LastAction;

    public bool CanMove = true;
    //private bool updatedMove = true;

    public int Lives;

    private bool InterMove;
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
        timeToMove = 0.3f;
        LastDirection = IVector.forward;
        Direction = IVector.back;
        Position = transform.position;
    }
        
    private new void Update()
    {
        LastTime -= Time.deltaTime;

        // Inter-mediate move (half way)
        if (LastTime < (timeToMove * 0.4f) && InterMove)
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

        /*
        // Get continuous Move intent
        if (Input.GetAxis("Horizontal") < 0)
            Move(IVector.left);

        else if (Input.GetAxis("Horizontal") > 0)
            Move(IVector.right);

        else if (Input.GetAxis("Vertical") > 0)
            Move(IVector.forward);

        else if (Input.GetAxis("Vertical") < 0)
            Move(IVector.back);

        */

        // Was pushing (continuously), and now stopped?
        if (OldState == State.Push && PlayerState != State.Push)
        {
            // Stop pushing sound
            //camObject.GetComponent<AudioSource>().Stop();
        }

        if (WantMoveMe > 0)
            WantMoveMe--;
    }


    public void MoveToPos(IVector vNewPos)
    {
        LastPosition = Position = vNewPos;
    }

    public new void Move(IVector direction)
    {
        if (PlayerState != State.Stoped && PlayerState != State.PushNoWalk)
            return;

        // Walkable floor over intended direction?
        Piece piece = MovableTo<Piece>(Position.Add(direction), IVector.Down * 2, Color.green);
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
        Fallable fallable = MovableTo<Fallable>(Position + direction, IVector.up, Color.green);
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
                fallable.Move(IVector.zero);
                print("LastDirection = " + LastDirection);
            }

        }


        // Push Movable
        if (movable != null)
            movable.Move(direction);

        // Move Player
        base.Move(direction);

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

            case Level.Piece.Monster:
                //If rrMonster(rrPieces(intX, intY).intMonsterID).blnEarth Then MoveableTo = False
                bUpdateMap = false;
                DontReplace = 2;
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
        Direction = IVector.back;

        // Reset bomb?

        return Lives;
    }

}
