using ReptonReturnsLogic.World;
using ReptonReturnsLogic.Pieces;

public class Egg : Rock
{
    public event Action OnCrack;

    public bool EggCracking;  //Public bEggCracking As Boolean

    private void Start()
    {
        base.Init();
    }

    private new void Update()
    {
        base.Update();

        CheckFall();

    }

    public override bool Move(IVector direction)
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
            //this.GetComponent<AudioSource>().Play();
            PlayingSnd = true;
        }


        // Egg should stop and crack if hits anything

        OnCrack?.Invoke();

        return true;
    }
}