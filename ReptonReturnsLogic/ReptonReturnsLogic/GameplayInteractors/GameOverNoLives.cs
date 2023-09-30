namespace ReptonReturnsLogic.GameplayInteractors
{
    internal class GameOverNoLives
    {
        public event Action OnGameOver;
        // IPlayer Player
        // Player.LifeList += checkGameOver;

        public void checkGameOver()
        {
            //OnGameOver?.
        }
    }
}

/*
 * ' Game over?
    If intPlayerLives < 0 Then
        iLevelCompeted = -2
        Exit Function
    End If
*/
