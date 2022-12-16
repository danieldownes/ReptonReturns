using UnityEngine;

public class Rock : Movable
{
    public bool Falling;
    public bool WasFalling;
    public bool FreeFall;
    public bool PlayingSnd;

    //public bool EggCracking;  //Public bEggCracking As Boolean


    private void Start()
    {
        base.Init();

        Falling = false;
        CheckIfFall();
    }

    private new void Update()
    {
        base.Update();

        if (LastTime > 0.00f)
            return;

        CheckIfFall();

        // Stop sound?
        if (Falling == false && PlayingSnd)
        {
            this.GetComponent<AudioSource>().Stop();
            PlayingSnd = false;
        }
    }

    public override bool Move(Vector3 direction)
    {
        // Not currently moving down?
        if (direction == Vector3.back && LastTime > 0.01f)
            return false;

        // Can't move up
        if (direction == Vector3.up)
            return false;

        // Space for the rock to move?

        Piece piece = MovableTo<Piece>(Position, direction);
        if (piece != null)
            return false;

        // Ok, start the move...

        base.Move(direction);

        CheckIfFall();

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


    public void CheckIfFall()
    {
        // Have we stopped falling?
        WasFalling = false;

        if (Falling && LastTime <= 0.0f)
        {
            Falling = false;
            WasFalling = true;

            // TODO: falling stop sound
            //If bPlayingSnd Then rrGame.PlayRockRumbleSound False
            //bPlayingSnd = False
            //If intPieceType = Rock Then ExSnds(5).PlaySound (False) Else ExSnds(8).PlaySound (False)
            /*
            if (pPieceType == Level.Piece.Egg)
            {
                CrackEgg();
                return;
            }
            */
        }
        else if (Falling)
            return;

        // Fall straight down?
        Piece piece = MovableTo<Piece>(Position, Vector3.down);
        if (piece != null)
            return;

        Falling = true;
        Move(Vector3.down);


        //if (sTemp == (char)Level.Piece.Space)
        //{
        /*
        // Is player currently moving under rock?
        if (game.playerObject.Position != (Position + Vector3.back))
        {
            // It is ok to make rock fall
            bFalling = true;
            this.Move(Vector3.back);
        }
        */
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