using UnityEngine;

public class Moveable2 : MonoBehaviour
{
	public int iId;
	
	public Level.Piece pPieceType;		//Public intPieceType As enmPieceType      ' Should only be Rock OR Egg
	
	public Vector3 Position;
	public Vector3 LastPosition;
	public Vector3 vLastPositionAbs;	// Last absolute position (repton shuffle + smoother tweens)

	public Vector3 Direction;         	// Current direction that we are rolling (if rolling at all)
	public Vector3 LastDirection;		// Last direction we rolled
	
	public float LastTime;
	public float TimeToMove;
	
}
