using ReptonReturnsLogic.World;

namespace ReptonReturnsLogic.Pieces;
public class Fallable : Movable
{
    public event Action StoppedFalling;

    public bool Falling;
    public bool WasFalling;
    public bool FreeFall;

    //public bool EggCracking;  //Public bEggCracking As Boolean


    public new void Init()
    {
        base.Init();

        Falling = false;
        CheckIfFall();
    }

    private new void Update()
    {
        base.Update();
    }

    public void CheckFall()
    {
        if (LastTime > 0.00f)
            return;

        CheckIfFall();
    }

    public override bool Move(IVector direction)
    {
        // Not currently moving down?
        if (direction == IVector.Down && LastTime > 0.01f)
            return false;

        // Can't move up
        if (direction == IVector.Up)
            return false;

        // Ok, start the move...

        base.Move(direction);

        CheckIfFall();

        return true;
    }

    public override void Traverse()
    {
        // overridden
    }

    public virtual void CheckIfFall()
    {
        // Have we stopped falling?
        WasFalling = false;

        if (Falling && LastTime <= 0.0f)
        {
            Falling = false;
            WasFalling = true;

            StoppedFalling?.Invoke();
        }
        else if (Falling)
            return;

        // Fall straight down?
        Piece piece = MovableTo<Piece>(Position, IVector.down);
        if (piece != null)
            return;


        // It is ok to make rock fall
        Falling = true;
        Move(IVector.Down);


        // Is a monster currently moving under rock?

        // Is player already under moving rock?

        // Still not falling?
        //  Try fall to the left..
        //if (!bFalling)

        // Is left-below rock still falling? If so, don't do anything until that rock is out of the way

        // Is the support currently under rock slanted to the left?

        // Check if room exists to the left (And Repton isn't there)
        // Check if room exists to 1 left, 1 down (And Repton isn't there)
        //sTemp = rrMap.GetData(intCurX - 1, intCurY + 1)   

        // This rock should fall to the left


        // Still not falling?
        //  Try fall to the right..
        // Is left-below rock still falling? If so, don't do anything until that rock is out of the way

        // Is the support currently under rock slanted to the right?

        // Check if room exists to the right (And Repton isn't there)

        // This rock should fall to the right


        // If rock is in free falling (ie, it has been falling before it was detected that it should fall
        //  again (directly afterward), then add count (so that it can be detected if it hit repton, or if this is
        //  an egg, if it should crack).
        //if (bFalling && bWasFalling)
        //    bFreeFall = true;
        //else
        //    bFreeFall = false;

        //}
    }
}