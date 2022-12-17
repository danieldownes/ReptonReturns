using UnityEngine;

public class Rock : Fallable
{
    public bool PlayingSnd;

    //public bool EggCracking;  //Public bEggCracking As Boolean

    private void Start()
    {
        base.Init();
    }

    private new void Update()
    {
        base.Update();

        CheckFall();

        // Stop sound?
        if (Falling == false && PlayingSnd)
        {
            this.GetComponent<AudioSource>().Stop();
            PlayingSnd = false;
        }
    }

    public override bool Move(Vector3 direction)
    {
        // Space for the rock to move?

        Piece piece = MovableTo<Piece>(Position, direction);
        if (piece != null)
            return false;

        //TODO: Check Traversable list, eg, Repton monster


        // Ok, start the move...

        if (base.Move(direction) == false)
            return false;


        // Play Rock Sound
        if (!PlayingSnd)
        {
            this.GetComponent<AudioSource>().Play();
            PlayingSnd = true;
        }


        // Before we do though, are there any monsters in the way? if so they should die..

        // Is monster under rock?
        //if (game.loadedLevel.GetMapP(Position) == (char)Level.Piece.Monster)
        //{
        //game.loadedLevel.KillMonsters(Position);
        //}

        return true;
    }

    public override void Traverse()
    {
        // overridden
    }

    public override void CheckIfFall()
    {
        base.CheckIfFall();


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