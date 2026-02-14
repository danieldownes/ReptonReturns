namespace ReptonReturnsLogic.GameplayInteractors
{
    internal class DefuseBomb
    {
        public bool Defused;

        // Totals in level:
        public int Diamonds;               //    \
        public int Crowns;                 //     -  All must = 0 before bomb can be defused
        public int Eggs;                   //    /
        public int MonstersAlive;          //   /
        public int Spirits;                //  /

        public bool CanDefuse()
        {
            if (Diamonds != 0)
                return false;

            if (Crowns != 0)
                return false;

            if (Eggs != 0)
                return false;

            if (MonstersAlive != 0)
                return false;

            if (Spirits != 0)
                return false;

            Defused = true;

            return true;
        }
    }
}
