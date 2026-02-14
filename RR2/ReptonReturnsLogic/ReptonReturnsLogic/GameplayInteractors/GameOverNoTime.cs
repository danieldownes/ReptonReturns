namespace ReptonReturnsLogic.GameplayInteractors
{
    internal class GameOverNoTime
    {
        public event Action OnGameOver;
        // IPlayer Player
        // Player.LifeList += checkGameOver;

        public void checkGameOver()
        {

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
