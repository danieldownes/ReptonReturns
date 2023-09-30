namespace ReptonReturnsLogic.GameplayInteractors
{
    internal class DieByBadMove
    {
        public event Action OnGameOver;
        public Player player;

        private DieByBadMove()
        {
            player.OnTraversed += Player_OnTraversed;
        }

        private void Player_OnTraversed()
        {
            if( Piece.Skull Piece.Fungus Monster)
                Die();
        }

    }
}
