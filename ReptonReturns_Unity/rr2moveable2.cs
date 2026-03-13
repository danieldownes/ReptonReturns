using UnityEngine;
using System.Collections;

public class rr2moveable2 : MonoBehaviour
{
	
	public rr2game rr2gameObject;
	
	public int iId; // lObjects ref
	
	public rr2level.enmPiece pPieceType; //Public intPieceType As enmPieceType      ' Should only be Rock OR Egg

	
	public Vector3 vPosition;
	public Vector3 vLastPosition;
	public Vector3 vLastPositionAbs; // Last absolute position (repton shuffle + smoother tweens)

	public Vector3 vDirection;         	// Current direction that we are rolling (if rolling at all)
	public Vector3 vLastDirection;			// Last direction we rolled
	
	public float fTime;
	public float fTimeToMove;
	
	
	public Vector3 AddSlant(Vector3 v)
	{
		return rr2gameObject.loadedLevel.AddSlant(v);
	}
}
