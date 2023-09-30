namespace ReptonReturnsLogic.GameplayInteractors
{
    internal class LevelCompleted
    {
        public event Action OnLevelCompleted;

        private Player player;
        private DefuseBomb defuseBomb;

        public LevelCompleted()
        {
            player.OnTraversed += Player_OnTraversed;
        }

        private void Player_OnTraversed()
        {
            // Game objectives
            if (defuseBomb.Defused == true)
                OnLevelCompleted?.Invoke();
        }
    }
}
