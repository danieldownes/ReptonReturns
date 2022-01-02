using UnityEngine;

public class Moveable2 : MonoBehaviour
{
	public Game game;
	
	public int iId;
	
	public Level.Piece pPieceType;		//Public intPieceType As enmPieceType      ' Should only be Rock OR Egg
	
	public Vector3 vPosition;
	public Vector3 vLastPosition;
	public Vector3 vLastPositionAbs;	// Last absolute position (repton shuffle + smoother tweens)

	public Vector3 vDirection;         	// Current direction that we are rolling (if rolling at all)
	public Vector3 vLastDirection;		// Last direction we rolled
	
	public float fTime;
	public float fTimeToMove;
	
	public Vector3 AddSlant(Vector3 v)
	{
		return game.loadedLevel.AddSlant(v);
	}
}
